class User < Idfix::Models::User
  has_many :avatars, :class_name => "Picture", :as => :holder do
    def current
      find(:first, :order => "created_at DESC")
    end
  end
  has_many :comments
  has_many :blog_posts, :foreign_key => :author_id
  has_many :user_articles, :foreign_key => :author_id

  named_scope :as_parent, Proc.new{|*args|
    {:conditions => ["remote_id = ?", args.first]}
  }
  
  cattr_reader :per_page
  @@per_page = 20

  def to_param
    self.remote_id
  end
end
