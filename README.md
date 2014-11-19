# Capistrano::Rbenv::Install

Capistrano plugin for **lightweight** rubies management with rbenv.

Works with Capistrano 3 (only). For Capistrano 2 support check
[this repository](https://github.com/yyuu/capistrano-rbenv)
(version 1.x of `capistrano-rbenv` gem).

### Installation

Install by adding the following to the `Gemfile`:

    gem 'capistrano', '~> 3.2.1'
    gem 'capistrano-rbenv', '~> 2.0' # required
    gem 'capistrano-rbenv-install', '~> 1.2.0'

then:

    $ bundle install

### Configuration and usage

The following goes to `Capfile`:

    require 'capistrano/rbenv_install'

This plugin heavily relies on
[capistrano-rbenv config options](https://github.com/capistrano/rbenv#usage).
So make sure to properly setup `capistrano-rbenv` and you'll be good.

For example, in `config/deploy.rb`:

    set :rbenv_ruby, '2.0.0-p247'

Other than that, this plugin does not need any setup.

Run:

    $ bundle exec cap production deploy

And watch ruby being installed.

### Purpose

Installing software packages on servers is called
[provisioning](http://en.wikipedia.org/wiki/Provisioning#Server_provisioning).
Installing and managing rubies falls into that domain, and is best done with a
proper tool like chef, puppet, ansible or something else.

Why this plugin then?

- Capistrano is a great tool (written in ruby btw) so, when there's a need,
installing rubies with it should be easy too
- not everyone knows (or has time to learn) how to use provisioning tools
mentioned above
- sometimes installing ruby manually is just easier than fiddling with your
chef cookbooks. Instead of manually, you can do it with this plugin now

Imagine you want to quickly deploy a ruby `1.9.2` app to a server that already
has one or more ruby `2.0.0` apps.
"Oh, let's just quickly update our cookbooks" - yea right! I'd rather manually
`ssh` to the server directly and run `rbenv install 1.9.2-p320`. But I don't
want to manually `ssh` to the server too. In that case I just can install
`capistrano-rbenv-install` and forget about it altogether.

### What it does

It only does the bare minimum that's required for Capistrano to work. That's
why it's a plugin for *lightweight* ruby management.

It makes sure that:

- `rbenv` and `ruby build` are installed (installs them using `git`)
- ruby specified with `:rbenv_ruby` option is installed
- `bundler` gem is installed

### What it does NOT do

It **does not**:

- manage ruby gems<br/>
`bundler` is installed by default and that's pretty much it.

- does not install ruby dependency packages<br/>
(git-core build-essential libreadline6-dev etc ...). You should probably
install/provision those some other way.

- does not manage `rbenv` plugins<br/>
It only installs `ruby build` for the purpose of installing ruby.

- does not setup rbenv for direct use on the server via the command line<br/>
Example: `ssh`ing to the server and manually running ruby commands is not
supported.

### More Capistrano automation?

Check out [capistrano-plugins](https://github.com/capistrano-plugins) github org.

### Thanks

@yyuu and the original
[capistrano-rbenv](https://github.com/yyuu/capistrano-rbenv) project for
inspiration

### License

[MIT](LICENSE.md)
