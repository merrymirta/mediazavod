class SectionsController < ApplicationController
  def show
    @section = Section.find_by_alias(params[:id])
    
    raise ActiveRecord::RecordNotFound if @section.nil?
    
    @articles = Article.publicated_at_section(@section).paginate(:all, :per_page => @section.articles_at_section || 10, :page => 1)
    @gallery  = Gallery.publicated_at_section(@section).find(:first)
    @shorties = Shorty.publicated_at_section(@section).find(:all, :limit => @section.shorties_at_section || 15)
  end
end
