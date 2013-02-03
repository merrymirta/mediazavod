class UserArticle < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  has_pictures

  acts_as_commentable
  acts_as_taggable

  named_scope :latest, {:order => "created_at DESC"}
  named_scope :visible, {:conditions => "state IN('approved', 'featured')"}
  named_scope :by_state, Proc.new{|state|
    state = state.is_a?(Array) ? state.collect{|s| s.to_s } : state.to_s

    {:conditions => ["state IN(?)", state]}
  }

  attr_accessible :title, :excerpt, :content

  acts_as_state_machine :initial => :draft

  state :draft
  state :approved
  state :featured
  state :declined
  state :deleted

  event :approve do
    transitions :from => [:draft, :declined], :to => :approved
  end

  event :feature do
    transitions :from => [:draft, :declined, :approved], :to => :featured
  end

  event :decline do
    transitions :from => [:draft, :approved, :featured], :to => :declined
  end

  event :mark_deleted do
    transitions :from => [:draft, :approved, :featured, :declined], :to => :deleted
  end

  def is_author?(user)
    user == self.author
  end

  def allow_comments?
    true
  end

  def name
    self.title
  end

  def first_sentences
    "#{self.content.to_s.split(".")[0..3]}."
  end

  def filter
    Rails.configuration.idfix.default_markup
  end

  def excerpt
    if self.content =~ /^(.*)<!--\s*more\s*-->/
      return $1
    else
      return first_sentences
    end
  end
end
