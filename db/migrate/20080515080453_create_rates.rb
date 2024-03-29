class CreateRates < ActiveRecord::Migration
  def self.up
    create_table :rates do |t|
      t.integer :rateable_id
      t.string  :rateable_type
      
      t.integer :user_id
      t.integer :ip
      
      t.integer :value
      
      t.timestamps
    end
  end

  def self.down
    drop_table :rates
  end
end
