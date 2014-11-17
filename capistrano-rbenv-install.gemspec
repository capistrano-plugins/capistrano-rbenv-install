# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/rbenv_install/version'

Gem::Specification.new do |gem|
  gem.name          = "capistrano-rbenv-install"
  gem.version       = Capistrano::RbenvInstall::VERSION
  gem.authors       = ["Bruno Sutic"]
  gem.email         = ["bruno.sutic@gmail.com"]
  gem.description   = <<-EOF.gsub(/^\s+/, '')
    Capistrano plugin for lightweight rubies management with rbenv.

    Works with Capistrano 3 (only!). For Capistrano 2 support see:
    https://github.com/yyuu/capistrano-rbenv
  EOF
  gem.summary       = "Capistrano plugin for lightweight rubies managment with rbenv."
  gem.homepage      = "https://github.com/capistrano-plugins/capistrano-rbenv-install"

  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ["lib"]

  gem.add_dependency 'capistrano', '>= 3.0'
  gem.add_dependency 'capistrano-rbenv', '>= 2.0'

  gem.add_development_dependency "rake"
end
