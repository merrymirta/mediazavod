namespace :idfix do
  namespace :permissions do
    desc "Migrate permissions from constant-based access rules"
    task :blogs => :environment do
      puts "Setting up blog permissions..."

      {
        :view             => ":publicated | :approved | :featured | .author | admin",
        :manage           => "admin",
        :create           => "admin | !banned",
        :edit             => "admin | .author",
        :publicate        => "(admin | .author) & :draft",
        :manage_pictures  => "(admin | .author) & :draft",
        :approve          => "admin & (:publicated | :declined)",
        :feature          => "admin & (:publicated | :approved | :declined)",
        :decline          => "admin & (:publicated | :approved | :featured)",
        :delete           => "(admin | .author) & !:deleted",
        :manage_comments  => "admin"
      }.each_pair do |key, value|
        Permission.create(:controllable_type => "BlogPost", :action => key.to_s, :rule => value)
      end
    end
  end
end