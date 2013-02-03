class Article < Material
  cattr_reader :per_page
  @@per_page = 10

  has_one :article_content
  has_pictures
  
  validates_presence_of :author_id, :excerpt,
    :message => ""[:common_validation_presence]

  validates_associated :article_content

  before_update :save_article_content
  
  def initialize(attributes = nil)
    attributes ||= {}

    super(attributes)
    
    self.build_article_content(attributes[:article_content]) if self.new_record?
  end

  def update_attributes(attributes)
    self.attributes = attributes

    self.article_content.attributes = attributes[:article_content]

    self.save
  end

  protected

  def save_article_content
    if self.article_content.changed?
      self.article_content.save

      self.updated_at = Time.now
    end
  end

  # Adds article content to search index. See Material#custom_search_index_options for details
  def self.custom_search_index_options(index)
    index.instance_eval do
      indexes article_content.text
    end
  end

  def do_publicate
    super

    if self.publicate_in_section_list
      Delayed::Job.enqueue(Jobs::Subscription::ArticleDelivery.new(self.id), 0, Time.now + 30.minutes)
    end
  end
end
