class NewspapersController < ApplicationController
  def show
    by_date
  end
  
  def by_date
    @section = Section.find_by_alias(params[:id])

    @active_days = Article.active_days_filtered(:section => @section.alias, :state => "publicated")

    begin
      @date = Date.parse(params[:date])
    rescue
      @date = @active_days.first
      @date ||= Date.today
    end
    
    @articles = Article.publicated_at_section(@section).find_all_by_publicated_at(
      @date.beginning_of_day .. @date.end_of_day
    )
    
    @shorties = Shorty.publicated_at_section(@section).find_all_by_publicated_at(
      @date.beginning_of_day .. @date.end_of_day
    )
    
    render :action => "by_date"
  end
end
