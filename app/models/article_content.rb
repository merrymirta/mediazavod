class ArticleContent < ActiveRecord::Base
  belongs_to :article

  validates_presence_of :text,
    :message => ""[:common_validation_presence]

  attr_accessible :text, :filter
  
  xss_terminate :except => [:text]

  def filter
    self[:filter] ||= Rails.configuration.idfix.default_markup
  end

  def format_imported_text
    self.filter = Idfix::Markup::TEXTILE
    
    self.text = self.text.
      gsub(/\r\n/m, "\n\n").
      gsub(/^-\s?/m, "\n--  ").
      gsub(/\n{3,}/, "\n\n").
      gsub(/\":/, "\" : ")
  end
end
