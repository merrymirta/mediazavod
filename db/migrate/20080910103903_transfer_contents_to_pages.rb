class TransferContentsToPages < ActiveRecord::Migration
  def self.up
    quoted_column_names = Page.column_names.map { |column| 
      ActiveRecord::Base.connection.quote_column_name(column)
    }.join(',')
    
    ActiveRecord::Base.connection.execute("INSERT INTO pages(#{quoted_column_names}) SELECT #{quoted_column_names} FROM contents")

    return true
  end

  def self.down
    
  end
end
