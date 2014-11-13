require 'capistrano/dsl/rbenv_install'

include Capistrano::DSL::RbenvInstall

# Heavily depends on 'capistrano-rbenv' variables:
# https://github.com/capistrano/rbenv/blob/master/lib/capistrano/tasks/rbenv.rake#L33-49
# set :rbenv_type               # :user or :system
# set :rbenv_ruby, '2.0.0-p247' # ruby version
# set :rbenv_roles, :all        # where rbenv should be installed
# set :rbenv_path,              # ~/.rbenv or /usr/local/rbenv, depends on :rbenv_type
# set :rbenv_ruby_dir           # "#{fetch(:rbenv_path)}/versions/#{fetch(:rbenv_ruby)}" }

namespace :rbenv do
  desc 'Install rbenv'
  task :install_rbenv do
    on roles fetch(:rbenv_roles) do
      next if test "[ -d #{fetch(:rbenv_path)} ]"
      execute :git, :clone, rbenv_repo_url, fetch(:rbenv_path)
    end
  end

  desc 'Install ruby build - rbenv plugin'
  task :install_ruby_build do
    on roles fetch(:rbenv_roles) do
      next if test "[ -d #{rbenv_ruby_build_path} ]"
      execute :git, :clone, ruby_build_repo_url, rbenv_ruby_build_path
    end
  end

  desc 'Update ruby build - rbenv plugin'
  task :update_ruby_build do
    on roles fetch(:rbenv_roles) do
      next if test "[ ! -d #{rbenv_ruby_build_path} ]"
      execute :git, "-C #{rbenv_ruby_build_path}", :pull
    end
  end

  desc 'Install ruby'
  task :install_ruby do
    on roles fetch(:rbenv_roles) do
      next if test "[ -d #{fetch(:rbenv_ruby_dir)} ]"
      execute rbenv_bin_executable_path, :install, fetch(:rbenv_ruby)
    end
  end


  desc 'Install bundler gem'
  task :install_bundler do
    on roles fetch(:rbenv_roles) do
      next if test :gem, :query, '--quiet --installed --name-matches ^bundler$'
      execute :gem, :install, :bundler, '--quiet --no-rdoc --no-ri'
    end
  end

  namespace :install do
    desc 'Remove bundler binmaps'
    task :remove_bundler_binmaps do
      on roles fetch(:rbenv_roles) do
        next unless Rake::Task.task_defined?('bundler:map_bins')
        SSHKit.config.command_map.prefix[:gem].reject! { |c| c == 'bundle exec' }
      end
    end

    desc 'Reinsert bundler binmaps'
    task :reinsert_bundler_binmaps do
      on roles fetch(:rbenv_roles) do
        next unless Rake::Task.task_defined?('bundler:map_bins')
        SSHKit.config.command_map.prefix[:gem].insert(1,'bundle exec')
      end
    end
  end

  desc 'Install rbenv, ruby build and ruby version'
  task :install do
    invoke 'rbenv:install_rbenv'
    invoke 'rbenv:install_ruby_build'
    invoke 'rbenv:install_ruby'
  end

  before 'rbenv:validate', 'rbenv:install'
  before 'rbenv:install_ruby', 'rbenv:update_ruby_build'
  after 'rbenv:map_bins', 'rbenv:install_bundler'

  before 'rbenv:install_bundler', 'rbenv:install:remove_bundler_binmaps'
  after 'rbenv:install_bundler', 'rbenv:install:reinsert_bundler_binmaps'
end
