class CreatePasswordChanges < ActiveRecord::Migration
  def self.up
    create_table :password_changes, :force => true do |t|
      t.string   :secure_key, :limit => 40
      t.integer  :user_id
      t.string   :state,                    :default => "pending", :null => false
    
      t.timestamps
    end

    add_index :password_changes, :secure_key
  end

  def self.down
    drop_table :password_changes
  end
end
