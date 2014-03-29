module Capistrano
  module DSL
    module RbenvInstall

      def rbenv_ruby_build_path
        "#{fetch(:rbenv_path)}/plugins/ruby-build"
      end

      def rbenv_bin_executable_path
        "#{fetch(:rbenv_path)}/bin/rbenv"
      end

      def rbenv_repo_url
        'https://github.com/sstephenson/rbenv.git'
      end

      def ruby_build_repo_url
        'https://github.com/sstephenson/ruby-build.git'
      end

    end
  end
end
