namespace :idfix do
  namespace :permissions do
    desc "Migrate permissions from constant-based access rules"
    task :publishing => :environment do
      puts "Setting up publishing permissions..."

      {
        :manage           => "admin | writer",
        :create           => "admin | writer",
        :edit             => "admin | (writer & :pending | :draft)",
        :send_to_test     => "admin | (writer & :draft)",
        :publicate        => "admin & (:draft | :pending | :publicated)",
        :delete           => "admin | (writer & :pending | :draft)",
        :manage_pictures  => "admin | (writer & :pending | :draft)",
        :manage_comments  => "admin",
        :manage_assets    => "admin"
      }.each_pair do |key, value|
        Permission.create(:controllable_type => "Article", :action => key.to_s, :rule => value)
      end

      {
        :manage           => "admin | photographer",
        :create           => "admin | photographer",
        :edit             => "admin | (photographer & :pending | :draft)",
        :send_to_test     => "admin | (photographer & :draft)",
        :publicate        => "admin & (:draft | :pending | :publicated)",
        :delete           => "admin | (photographer & :pending | :draft)",
        :manage_pictures  => "admin | (photographer & :pending | :draft)",
        :manage_comments  => "admin",
        :manage_assets    => "admin"
      }.each_pair do |key, value|
        Permission.create(:controllable_type => "Gallery", :action => key.to_s, :rule => value)
      end

      {
        :manage           => "admin | writer",
        :create           => "admin | writer",
        :edit             => "admin | (writer & :pending | :draft)",
        :send_to_test     => "admin | (writer & :draft)",
        :publicate        => "admin & (:draft | :pending | :publicated)",
        :delete           => "admin | (writer & :pending | :draft)",
        :manage_pictures  => "nobody",
        :manage_comments  => "admin"
      }.each_pair do |key, value|
        Permission.create(:controllable_type => "Shorty", :action => key.to_s, :rule => value)
      end

      Permission.create(:controllable_type => "Material", :action => "upload_archive", :rule => "admin")

      puts "Setting up blog permissions..."

      {
        :view             => ":approved | :featured | .author | admin",
        :manage           => "admin",
        :create           => "admin | !banned",
        :edit             => "admin | (.author & draft)",
        :manage_pictures  => "(admin | .author) & :draft",
        :approve          => "admin & (:draft | :featured | :declined)",
        :feature          => "admin & (:draft | :approved | :declined)",
        :decline          => "admin & (:draft | :approved | :featured)",
        :delete           => "(admin & !:deleted) | (.author & :draft)",
        :manage_comments  => "admin"
      }.each_pair do |key, value|
        Permission.create(:controllable_type => "UserArticle", :action => key.to_s, :rule => value)
      end
    end
  end
end