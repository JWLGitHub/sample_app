load "deploy/assets"

set :application, "sample_app"                               # Application being deployed

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :repository,  "git@github.com:JWLGitHub/sample_app.git"  # Location of Application source code repository

set :user,          "sample_app"                             # deploy user
set :use_sudo,      false                                    # PROHIBIT "sudo" command 
set :deploy_to,     "/home/sample_app/apps/#{application}"   # deploy path
set :keep_releases, 5                                        # Keep last 5 deployments
default_run_options[:shell] = '/bin/bash --login'            # Use the bash prompt to send commands thru


role :web, "192.168.0.34"                          # Your HTTP server, Apache/etc
role :app, "192.168.0.34"                          # This may be the same as your `Web` server
role :db,  "192.168.0.34", :primary => true        # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end