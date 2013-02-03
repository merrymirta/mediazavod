class AddInidcesToTables < ActiveRecord::Migration
  def self.up
    remove_index :materials, :name => :index_articles_on_state

    add_index :materials, [:type, :state, :publicated_at]
  end

  def self.down
    add_index :materials, :state
    
    remove_index :materials, [:type, :state, :publicated_at]
  end
end
