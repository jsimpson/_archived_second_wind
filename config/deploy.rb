require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
#require 'mina/rbenv'

# Basic settings:
set :term_mode, nil
set :domain, 'jsimpson.webfactional.com'
set :repository, 'git@github.com:jsimpson/second_wind.git'
set :branch, 'master'

#case ENV['to']
#when 'production'
set :deploy_to, '/home/jsimpson/webapps/sw'
set :env, 'production'
#else
#  set :deploy_to, '/home/jsimpson/webapps/sw_staging'
#  set :env, 'staging'
#end

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'log', 'public/uploads']

# Optional settings:
set :user, 'jsimpson'    # Username in the server to SSH to.
# set :port, '7331'     # SSH port number.

set :bundle_bin, %{PATH="#{deploy_to}/bin:$PATH" GEM_HOME="#{deploy_to}/gems" RUBYLIB="#{deploy_to}/lib" RAILS_ENV=#{env} #{deploy_to}/bin/bundle}

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  #invoke :'rbenv:load'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/secrets.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/secrets.yml'."]

  queue! %[mkdir -p "#{deploy_to}/shared/public/uploads"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/uploads"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      queue %{#{deploy_to}/bin/restart}
    end
  end
end

namespace :nginx  do
  task :start => :environment do
    queue %{#{deploy_to}/bin/start}
  end

  task :stop => :environment do
    queue %{#{deploy_to}/bin/stop}
  end

  task :restart => :environment do
    queue %{#{deploy_to}/bin/restart}
  end
end

task :logs do
  queue 'echo "[ TAIL CONTENTS OF LOG FILE ]"'
  queue %{tail -f #{deploy_to}/current/log/#{env}.log}
end

task :console => :environment do
  queue 'echo "[ STARTING EXTERNAL RAILS CONSOLE ]"'
  queue %{#{bundle_bin} exec rails c}
end
