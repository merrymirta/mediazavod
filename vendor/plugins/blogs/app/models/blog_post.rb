class BlogPost < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  has_pictures

  acts_as_commentable
  acts_as_taggable

  attr_accessible :title, :excerpt, :content, :tag_list

  named_scope :latest, {:order => "created_at DESC"}
  named_scope :visible, {:conditions => "state IN('publicated', 'approved', 'featured')"}
  named_scope :by_state, Proc.new{|state|
    state = state.is_a?(Array) ? state.collect{|s| s.to_s } : state.to_s
    
    {:conditions => ["state IN(?)", state]}
  }

  acts_as_state_machine :initial => :draft

  state :draft
  state :publicated
  state :approved
  state :featured
  state :declined
  state :deleted

  event :publicate do
    transitions :from => :draft, :to => :publicated
  end

  event :approve do
    transitions :from => [:publicated, :declined], :to => :approved
  end

  event :feature do
    transitions :from => [:publicated, :declined, :approved], :to => :featured
  end

  event :decline do
    transitions :from => [:publicated, :approved, :featured], :to => :declined
  end

  event :mark_deleted do
    transitions :from => [:publicated, :approved, :featured, :declined, :draft], :to => :deleted
  end

  xss_terminate :except => [:content]

  def is_author?(user)
    user == self.author
  end

  def name
    self.title
  end
end