require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)
set :rails_env, 'development'
set :domain, '192.168.1.39'
set :term_mode, nil
set :branch, 'master'
set :deploy_to, "/var/www/UK"
set :repository, 'git@192.168.1.39:maks_ohs/uk.git'

set :user, 'maks'
set :ssh_options, '-A'
set :rvm_path, '/usr/share/rvm/scripts/rvm'

# set :puma_config, "config/puma_#{env}.rb"
# set :unicorn_config, "config/unicorn.rb"

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log', 'tmp', 'public/uploads']

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  invoke :'rvm:use[ruby-2.2.2@default]'
end

task setup: :environment do
  queue! %(mkdir -p "#{deploy_to}/shared/log")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/log")

  queue! %(mkdir -p "#{deploy_to}/shared/config")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/config")

  queue! %(touch "#{deploy_to}/shared/config/database.yml")
  queue %(echo "-----> Be sure to edit 'shared/config/database.yml'.")

  queue! %(mkdir -p "#{deploy_to}/shared/public/uploads")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/public/uploads")

  queue! %(mkdir -p "#{deploy_to}/shared/tmp")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/tmp")

  queue! %(mkdir -p "#{deploy_to}/shared/tmp/sockets")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/sockets")

  queue! %(mkdir -p "#{deploy_to}/shared/tmp/pids")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids")

  # sidekiq needs a place to store its pid file and log file
  queue! %(mkdir -p "#{deploy_to}/shared/pids/")
  queue! %(mkdir -p "#{deploy_to}/shared/log/")
end

desc 'Deploys the current version to the server.'
task deploy: :environment do
  deploy do
    invoke :'git:clone'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:link_shared_paths'

    to :launch do
      invoke :'passenger:restart'
    end
  end
end
namespace :passenger do
  task :restart do
    queue %(
      echo "-----> Restarting passenger"
      #{echo_cmd %(mkdir -p tmp)}
      #{echo_cmd %(touch tmp/restart.txt)}
    )
    # queue! %["sudo cp -R #{deploy_to}/current/app/assets/images/* #{deploy_to}/current/public/assets/"]
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
