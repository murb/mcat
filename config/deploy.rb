# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'cat.murb.nl'
set :repo_url, 'cat@murb.nl:/home/cat/source-catm.git'

set :main_user, 'cat'

set :bundle_bins, []
set :bundle_roles, :all
set :bundle_binstubs, -> { shared_path.join('bin') }
set :bundle_gemfile, -> { release_path.join('Gemfile') }
set :bundle_path, -> { shared_path.join('bundle') }
set :bundle_without, %w{development test}.join(' ')
set :bundle_flags, ''

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.2.2'
set :rbenv_roles, :all # default value


# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '~/public/cat.murb.nl'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push("db/#{fetch(:stage)}.sqlite3")

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 3 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  desc 'Show logs'
  task :log do
    on roles(:app), in: :sequence, wait: 5 do
      execute :tail, " -n 100 #{shared_path}/log/production.log"
    end
  end
end