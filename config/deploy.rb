set :application, "publishing"
set :repository,  "git@git.railorz.com:mz/publishing.git"

set :use_sudo, false
# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "mediazavod.ru"
role :web, "mediazavod.ru"
role :db,  "mediazavod.ru", :primary => true

set :deploy_to, "/home/site/#{application}"

set :user, "site"
set :password, "TTh7d00r"

set :scm, "git"
set :branch, "master"
set :git_enable_submodules, 1 # Подключает загрузку внешних модулей
set :deploy_via, :remote_cache

default_environment["RAILS_ENV"] = "production"

namespace :deploy do
  desc "Restart service"
  task :restart, :roles => :app do
    deploy.appserver.restart
  end

  desc "Start service"
  task :start, :roles => :app do
    deploy.appserver.restart
  end

  desc "Stop service"
  task :stop, :roles => :app do
    deploy.appserver.restart
  end

  desc "Update symlinks to uploaded files"
  task :after_update_code do
    configure_service
    update_symlinks
    install_cron
  end

  desc "Configure current service"
  task :configure_service do
    run "cd #{release_path}; rake gems:install; rake service:configure"
  end

  desc "Update symlinks for current release"
  task :update_symlinks do
    # Создаем папки парсера и ставим ссылки
    %w{parser parser/new/rabochy parser/new/ug parser/archive/rabochy parser/archive/ug}.each do |folder|
      run "mkdir -p #{shared_path}/#{folder}"
    end
    run "ln -s #{shared_path}/parser #{release_path}/parser"

    # Обновляем ссылки на публичные файлы
    run "mkdir -p #{shared_path}/pictures; ln -s #{shared_path}/pictures #{release_path}/public/pictures"
    run "mkdir -p #{shared_path}/games; ln -s #{shared_path}/games #{release_path}/public/games"
    run "mkdir -p #{shared_path}/backup; ln -s #{shared_path}/backup #{release_path}/backup"
  end

  desc "Remove page cache"
  task :remove_page_cache do
    # Обновляем ссылки на публичные файлы
    run "rm -rf #{deploy_to}/../_cache/#{application}"
  end

  desc "Install crontab"
  task :install_cron do
    config = <<-CODE
      PATH = /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
      RAILS_ENV=production

      00 */8 * * * cd /home/site/publishing/current && rake app:sitemap:generate --trace >> /home/site/publishing/shared/log/cron.log 2>&1
      */15  * * * * cd /home/site/publishing/current && rake publicator:parse >> /home/site/publishing/shared/log/cron.log 2>&1
      */15  * * * * cd /home/site/classifieds/current && rake publicator:parse idfix:classifieds:recalculate_counters ts:stop ts:index ts:start >> /home/site/classifieds/shared/log/cron.log 2>&1
      00 01 * * * cd /home/site/publishing/current && rake app:backup >> /home/site/publishing/shared/log/backup.log 2>&1
      00 06 * * * cd /home/site/publishing/current && rake currency_rates:parse >> /home/site/publishing/shared/log/currency_rates.log 2>&1
      00 06 * * * cd /home/site/classifieds/current && rake currency_rates:parse >> /home/site/classifieds/shared/log/currency_rates.log 2>&1
      00 04 * * * cd /home/site/publishing/current && rake app:comments:delete >> /home/site/publishing/shared/log/banned_comments.log 2>&1
    CODE

    put(config, "#{shared_path}/crontab.conf")

    run "crontab #{shared_path}/crontab.conf"
  end

  namespace :appserver do
    desc "Restart Passenger instances"
    task :restart, :roles => :app do
      run "touch #{current_path}/tmp/restart.txt"
    end
  end

  namespace :jobs do
    desc "Start background jobs"
    task :start, :roles => :app do
      run "cd #{current_path}; ./script/jobs -e production start"
    end

    desc "Stop background jobs"
    task :stop, :roles => :app do
      run "cd #{current_path}; ./script/jobs -e production stop"
    end
  end
end

%w{deploy deploy:migrations}.each do |t|
  before t, "deploy:jobs:stop"

  after t, "deploy:jobs:start"
  after t, "deploy:remove_page_cache"
  after t, 'deploy:cleanup'
end