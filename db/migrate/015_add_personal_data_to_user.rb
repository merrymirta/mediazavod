class AddPersonalDataToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name,   :string
    add_column :users, :last_name,    :string
    add_column :users, :middle_name,  :string
    
    add_column :users, :blog_url,     :string
    add_column :users, :about,        :text
  end

  def self.down
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :middle_name
    
    remove_column :users, :blog_url
    remove_column :users, :about
  end
end
