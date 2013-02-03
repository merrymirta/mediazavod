class CreateMaterialsTable < ActiveRecord::Migration
  def self.up
    system("mysqldump -u %s --password=\"%s\" --databases %s > %s" % [
        ActiveRecord::Base.configurations[Rails.environment]["username"], 
        ActiveRecord::Base.configurations[Rails.environment]["password"],
        ActiveRecord::Base.configurations[Rails.environment]["database"],
        File.join(RAILS_ROOT, "tmp", "database-#{Time.now.to_s(:db).gsub(/\s+/, "-")}.sql")
      ]
    ) if Rails.production?
    
    rename_table :articles, :materials

    add_column :materials, :type, :string
    ActiveRecord::Base.connection.execute("UPDATE materials SET type = 'Article'")

    Picture.update_all(
      "container_type='Material'", "container_type='Article'"
    )
    Comment.update_all(
      "commentable_type='Material'", "commentable_type='Article'"
    )
    CommentSummary.update_all(
      "commentable_type='Material'", "commentable_type='Article'"
    )
    Rate.update_all(
      "rateable_type='Material'", "rateable_type='Article'"
    )
    RateSummary.update_all(
      "rateable_type='Material'", "rateable_type='Article'"
    )
    Tagging.update_all(
      "taggable_type='Material'", "taggable_type='Article'"
    )
    
    add_column :materials, :filter, :integer

    ActiveRecord::Base.transaction do
      # Copying data from several classes to single table
      [Shorty, Gallery].each do |klass|
        klass.find_by_sql("SELECT * FROM #{klass.to_s.tableize}").each do |old_one|
          new_one = klass.new
          
          # Assiging attributes
          old_one.attributes.each_pair do |key, value|
            new_one.send("#{key}=", value) unless key.to_sym == :id
          end

          new_one.save!
          new_one.publicate! if old_one.publicated?

          Picture.update_all(
            "container_id=#{new_one.id}, container_type='Material'",
            "container_id=#{old_one.attributes["id"]} AND container_type='#{klass}'"
          )

          Comment.update_all(
            "commentable_id=#{new_one.id}, commentable_type='Material'",
            "commentable_id=#{old_one.attributes["id"]} AND commentable_type='#{klass}'"
          )

          CommentSummary.update_all(
            "commentable_id=#{new_one.id}, commentable_type='Material'",
            "commentable_id=#{old_one.attributes["id"]} AND commentable_type='#{klass}'"
          )
          
          Rate.update_all(
            "rateable_id=#{new_one.id}, rateable_type='Material'",
            "rateable_id=#{old_one.attributes["id"]} AND rateable_type='#{klass}'"
          )

          RateSummary.update_all(
            "rateable_id=#{new_one.id}, rateable_type='Material'",
            "rateable_id=#{old_one.attributes["id"]} AND rateable_type='#{klass}'"
          )
          
          Tagging.update_all(
            "taggable_id=#{new_one.id}, taggable_type='Material'",
            "taggable_id=#{old_one.attributes["id"]} AND taggable_type='#{klass}'"
          )
        end
      end
    end
  end

  # WARNING: This migration has no way back!
  def self.down
    raise %{
      CreateMaterialsTable migration has no way back!
      Please restore your database manually from dump
      located at tmp/database-{date}.sql
    }
  end
end
