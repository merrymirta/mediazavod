class Material < ActiveRecord::Base
  include ActsAsFilterable, ActsAsPublicable, ActsAsTagged

  belongs_to  :section
  belongs_to  :author, :class_name => "User"
  has_assets

  validates_presence_of :section_id, :author_id, :name,
    :message => ""[:common_validation_presence]

  acts_as_taggable
  acts_as_rateable
  acts_as_commentable
  acts_as_publicable

  attr_accessible(
    :name,
    :section_id,
    :author_id,
    :tag_list,
    :excerpt,
    :filter,
    :source_name,
    :source_url,
    :publicate_as_hot,
    :publicate_at_homepage,
    :publicate_at_section,
    :publicate_in_general_digest,
    :publicate_in_section_digest,
    :publicate_in_general_list,
    :publicate_in_section_list,
    :publicate_in_ya_news,
    :allow_comments,
    :comment_policy,
    :allow_rating,
    :ya_news_text
  )

  xss_terminate :except => [:excerpt]

  named_scope :by_author, Proc.new {|value|
    {
      :conditions => {:author_id => value.is_a?(User) ? value.id : value}
    }
  }
  named_scope :except, Proc.new{|material|
    {
      :conditions => ["materials.id != ?", material.is_a?(Material) ? material.id : material]
    }
  }
  named_scope :author_ids, :select => "DISTINCT(author_id)"

  after_save :touch_section

  def filter
    self[:filter] ||= Rails.configuration.idfix.default_markup
  end

  def self.types
    [self, Article, Gallery, Shorty]
  end
  
  def self.setup_search_index
    return unless (table_exists? && respond_to?(:define_index) && self != Material)

    klass = self
    
    define_index do
      indexes :name
      indexes :excerpt
      indexes tags(:name), :as => :tag_list

      has publicated_at, :as => :date
      has section_id

      where "materials.state = 'publicated'"

      klass.custom_search_index_options(self)
    end

    ::Search.document_types << self
  end

  # Adds custom rules to default search index. Usage:
  #
  #  def self.custom_search_index_options(index)
  #    indexes some_field
  #    has filter_field
  #  end
  #
  def self.custom_search_index_options(index)
    
  end

  protected

  def touch_section
    self.section.update_attribute(:updated_at, Time.now)
  end
end