require "bundler/capistrano"
require "rvm/capistrano"

set :application, "demo"
set :deploy_to, "/opt/#{application}"

set :scm, :git
set :scm_user, "moretto-nik"
set :repository, "git@github.com:xpeppers/beancounter_rails.git"
set :branch, "master"

set :user, 'deploy'
ssh_options[:forward_agent] = true
ssh_options[:keys] = ["#{ENV['HOME']}/.ssh/deploy"]
default_run_options[:pty] = true

role :web, "10.0.1.250:2224"                         # Your HTTP server, Apache/etc
role :app, "10.0.1.250:2224"                         # This may be the same as your `Web` server
role :db,  "10.0.1.250:2224", :primary => true        # This is where Rails migrations will run

set :keep_releases, 5
after "deploy:update", "deploy:cleanup"
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
