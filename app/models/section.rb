class Section < ActiveRecord::Base
  has_many :materials
  
  has_many :articles
  has_many :galleries
  has_many :shorties

  attr_accessible :description, :articles_at_homepage, :shorties_at_homepage, :articles_at_section, :shorties_at_section, :additional_text

  xss_terminate :except => [:additional_text]
end
