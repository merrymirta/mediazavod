class CreateRateSummaries < ActiveRecord::Migration
  def self.up
    create_table :rate_summaries do |t|
      t.integer :rateable_id
      t.string  :rateable_type
      
      t.integer :total_count
      t.integer :total_value
      t.float   :average_value
    end
  end

  def self.down
    drop_table :rate_summaries
  end
end
