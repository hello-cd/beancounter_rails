require "bundler/capistrano"
require "rvm/capistrano"

set :application, "demo"
set :deploy_to, "/opt/#{application}"

set :scm, :git
set :scm_user, "moretto-nik"
set :repository, "git@github.com:xpeppers/beancounter_rails.git"
set :branch, "master"

set :user, 'vagrant'
set :scm_passphrase, "vagrant"
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

role :web, "192.168.10.10"                         # Your HTTP server, Apache/etc
role :app, "192.168.10.10"                         # This may be the same as your `Web` server
role :db, "192.168.10.10", :primary => true        # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
set :keep_releases, 5
after "deploy:update", "deploy:cleanup"
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
