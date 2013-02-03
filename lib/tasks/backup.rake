require 'rubygems'
require 'logger'
require 'benchmark'
require 'ping'
require 'fileutils'
require 'open3'

RSYNC = {
  :host     => "10.74.10.1",
  :login    => "mediazavod",
  :password => "eHBJoX9e",
  :path     => "/home/mediazavod/backup/publishing"
}
LOG_FILE = '/var/log/rrsync.log'
LOG_AGE = 'daily'

EMPTY_DIR     = '/tmp/empty_rsync_dir/'
DEBUG = true
SILENT = false

namespace :app do
  desc "Backup data"
  task :backup => :environment do
    db_config = YAML.load_file(File.join(RAILS_ROOT, "config", "database.yml"))[Rails.env]

    system("mysqldump -u #{db_config["username"]} --password='#{db_config["password"]}' --databases mediazavod_publishing_production mediazavod_passport_production mediazavod_banners_production mediazavod_classifieds_production > backup/database.sql")
    system("tar -czf backup/database-#{Time.now.strftime("%Y-%m-%d")}.tar.gz backup/database.sql")
    system("rm backup/database.sql")

    old_archives = Dir["backup/database-*.sql"].sort
    3.times do
      old_archives.pop
    end
    system("rm #{old_archives.join(" ")}") if old_archives.any?

    Rake::Task["app:backup:rsync"].execute(nil)
  end

  namespace :backup do
    desc "Upload using rsync"
    task :rsync do
      if DEBUG && !SILENT
        logger = Logger.new(STDOUT, LOG_AGE)
      elsif LOG_FILE != '' && !SILENT
        logger = Logger.new(LOG_FILE, LOG_AGE)
      else
        logger = Logger.new(nil)
      end
      rsync_cmd = "rsync -v --force --delete-before --delete-excluded -a -l -k backup #{RSYNC[:login]}@#{RSYNC[:host]}:#{RSYNC[:path]}"

      logger.info("Started running at: #{Time.now}")
      run_time = Benchmark.realtime do
        begin
          raise Exception, "Unable to find remote host (#{RSYNC[:host]})" unless Ping.pingecho(RSYNC[:host])

          FileUtils.mkdir_p("#{EMPTY_DIR}")
          Open3::popen3("#{rsync_cmd}") { |stdin, stdout, stderr|
            tmp_stdout = stdout.read.strip
            tmp_stderr = stderr.read.strip
            logger.info("#{rsync_cmd}\n#{tmp_stdout}") unless tmp_stdout.empty?
            logger.error("#{rsync_cmd}\n#{tmp_stderr}") unless tmp_stderr.empty?
          }
          FileUtils.rmdir("#{EMPTY_DIR}")
        rescue Errno::EACCES, Errno::ENOENT, Errno::ENOTEMPTY, Exception => e
          logger.fatal(e.to_s)
        end
      end
      logger.info("Finished running at: #{Time.now} - Execution time: #{run_time.to_s[0, 5]}")
    end
  end
end