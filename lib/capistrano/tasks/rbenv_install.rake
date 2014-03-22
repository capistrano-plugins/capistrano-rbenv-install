namespace :load do
  task :defaults do
    # Heavily depends on 'capistrano-rbenv' variables:
    # https://github.com/capistrano/rbenv/blob/master/lib/capistrano/tasks/rbenv.rake#L33-49
    # set :rbenv_type               # :user or :system
    # set :rbenv_ruby, '2.0.0-p247' # ruby version
    # set :rbenv_roles, :all        # where rbenv should be installed
    # set :rbenv_path,              # ~/.rbenv or /usr/local/rbenv, depends on :rbenv_type
    # set :rbenv_ruby_dir           # "#{fetch(:rbenv_path)}/versions/#{fetch(:rbenv_ruby)}" }

    set :rbenv_ruby_build_path, -> { "#{fetch(:rbenv_path)}/plugins/ruby-build" }
  end
end

namespace :rbenv do
  desc 'Install rbenv'
  task :install_rbenv do
    on roles fetch(:rbenv_roles) do
      next if test "[ -d #{fetch(:rbenv_path)} ]"
      execute :git, "clone https://github.com/sstephenson/rbenv.git #{fetch(:rbenv_path)}"
    end
  end

  desc 'Install ruby build - rbenv plugin'
  task :install_ruby_build do
    on roles fetch(:rbenv_roles) do
      next if test "[ -d #{fetch(:rbenv_ruby_build_path)} ]"
      execute :git, "clone https://github.com/sstephenson/ruby-build.git #{fetch(:rbenv_ruby_build_path)}"
    end
  end

  desc 'Install ruby'
  task :install_ruby do
    on roles fetch(:rbenv_roles) do
      next if test "[ -d #{fetch(:rbenv_ruby_dir)} ]"
      execute "#{fetch(:rbenv_path)}/bin/rbenv install #{fetch(:rbenv_ruby)}"
    end
  end

  desc 'Install bundler gem'
  task :install_bundler do
    on roles fetch(:rbenv_roles) do
      next if test :gem, "query --quiet --installed --name-matches ^bundler$"
      execute :gem, "install bundler --quiet --no-rdoc --no-ri"
    end
  end

  desc 'Install rbenv, ruby build and ruby version'
  task :install do
    invoke "rbenv:install_rbenv"
    invoke "rbenv:install_ruby_build"
    invoke "rbenv:install_ruby"
  end

  before 'rbenv:validate', 'rbenv:install'
  after 'rbenv:map_bins', 'rbenv:install_bundler'
end
