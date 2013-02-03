class RemoveLegacyTables < ActiveRecord::Migration
  def self.up
    %w(rates rate_summaries users roles roles_users pictures password_changes comments).each do |table|
      drop_table(table)
    end
  end

  def self.down
    create_table "rate_summaries", :force => true do |t|
      t.integer "rateable_id",   :limit => 11
      t.string  "rateable_type"
      t.integer "total_count",   :limit => 11
      t.integer "total_value",   :limit => 11
      t.float   "average_value"
    end

    create_table "rates", :force => true do |t|
      t.integer  "rateable_id",   :limit => 11
      t.string   "rateable_type"
      t.integer  "user_id",       :limit => 11
      t.integer  "ip",            :limit => 11
      t.integer  "value",         :limit => 11
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "roles", :force => true do |t|
      t.string "title"
    end

    create_table "roles_users", :id => false, :force => true do |t|
      t.integer "role_id", :limit => 11
      t.integer "user_id", :limit => 11
    end

    create_table "users", :force => true do |t|
      t.string   "login"
      t.string   "email"
      t.string   "crypted_password",          :limit => 40
      t.string   "salt",                      :limit => 40
      t.string   "remember_token"
      t.datetime "remember_token_expires_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "state",                     :limit => 20, :default => "passive"
      t.datetime "activated_at"
      t.datetime "deleted_at"
      t.string   "activation_code",           :limit => 40
      t.integer  "secret_question",           :limit => 11
      t.string   "secret_answer"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "middle_name"
      t.string   "blog_url"
      t.text     "about"
    end
    
    create_table "pictures", :force => true do |t|
      t.string   "name"
      t.integer  "holder_id",    :limit => 11
      t.integer  "size",         :limit => 11
      t.string   "content_type"
      t.string   "filename"
      t.integer  "height",       :limit => 11
      t.integer  "width",        :limit => 11
      t.integer  "parent_id",    :limit => 11
      t.string   "thumbnail"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "position",     :limit => 11
      t.string   "holder_type"
      t.integer  "user_id",      :limit => 11
      t.string   "state",                      :default => "recommended"
    end

    create_table "password_changes", :force => true do |t|
      t.string   "secure_key", :limit => 40
      t.integer  "user_id",    :limit => 11
      t.string   "state",                    :default => "pending", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "comments", :force => true do |t|
      t.integer  "parent_id",        :limit => 11
      t.integer  "root_id",          :limit => 11
      t.integer  "lft",              :limit => 11
      t.integer  "rgt",              :limit => 11
      t.integer  "commentable_id",   :limit => 11
      t.string   "commentable_type"
      t.integer  "user_id",          :limit => 11
      t.string   "user_name"
      t.string   "user_email"
      t.string   "user_site"
      t.text     "text"
      t.string   "state",                          :default => "pending"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
