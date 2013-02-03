class MaterialsController < ApplicationController
  # Trying to figure out material type
  before_filter :assign_material_type
  layout :layout_from_material_type

  helper_method :filter_options

  def index
    respond_to do |format|
      format.html do
        @materials = @type.paginate_filtered(filter_options)

        render_with_material :action => "index"
      end

      format.rss do
        @materials = @type.paginate_filtered(filter_options)
        
        render_with_material :action => "index"
      end

      format.js do
        @materials = @type.paginate_filtered(filter_options.merge(:per_page => 5))

        render_with_material :action => "index"
      end
    end
  end

  def homepage
    @materials = @type.publicated_at_homepage.paginate_filtered(filter_options)
    
    render_with_material :action => "index"
  end

  def informer
    respond_to do |format|
      format.js
    end
  end

  def show
    if logged_in? and object_permit?(@type, :manage)
      @material = @type.find(params[:id])
    else
      @material = @type.publicated.find(params[:id])
    end
    
    render_with_material :action => "show"
  end
  
  def sitemap
    @materials = @type.publicated.paginate(:page => params[:page], :per_page => 10000)
    
    respond_to do |format|
      format.xml do
        render_with_material :action => :sitemap, :layout => false
      end
    end
  end

  def yanews
    @materials = @type.publicated.paginate(:conditions => "publicate_in_ya_news = 1", :page => 1)

    respond_to do |format|
      format.rss do
        render_with_material :action => :yanews, :layout => false
      end
    end
  end

  protected

  def render_with_material(options)
    scoped_options = options.dup
    scoped_options[:template] = "#{@type.to_s.tableize}/#{scoped_options.delete(:action)}"

    begin
      render(scoped_options)
    rescue ActionView::MissingTemplate
      render(options)
    end
  end

  def material_translate(key, *args)
    text = ""[*args.dup.unshift("#{@type.to_s.tableize}_#{key}".to_sym)]
    text = ""[*args.dup.unshift("materials_#{key}".to_sym)] if text.blank?

    return text
  end
  
  def assign_material_type
    @type = params[:material_type] ? params[:material_type].classify.constantize : Material
  end
  
  def layout_from_material_type
    return false if [:inline, :rss, :js, :xml].include?(request.format.to_sym)
    return @type.to_s.tableize
  end

  def filter_options
    @filter_options ||= {
      :state    => "publicated",

      :tag      => params[:tag_id],
      :section  => params[:section_id],
      :author   => params[:user_id],
      :date     => params[:date],
      :page     => params[:page]
    }
  end
end