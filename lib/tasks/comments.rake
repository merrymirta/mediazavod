namespace :app do
  namespace :comments do
    desc "Delete old banned comments"
    task :delete => :environment do
      comments = Comment.find(:all, :conditions => ["state = ? and updated_at < ? ", "declined", Time.now - 24.hours])

      comments.each do |comment|
        comment.destroy_descendants
      end

      puts "Done"
    end
  end
end
