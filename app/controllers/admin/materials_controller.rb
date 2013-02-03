class Admin::MaterialsController < ApplicationController
  require_login

  # Trying to figure out material type
  before_filter :assign_material_type

  helper_method :filter_options, :material_translate

  def index
    if params[:id]
      ids = params[:id].split(",").collect{|i| i.strip}

      @materials = @type.paginate(:conditions => ["id IN(?)", ids], :page => params[:page])
    else
      @materials = @type.paginate_filtered(filter_options)
    end

    render_with_material :action => "index"
  end

  def show
    if logged_in? and object_permit?(@type, :manage)
      @material = @type.find(params[:id])
    else
      @material = @type.publicated.find(params[:id])
    end
    
    render_with_material :action => "show"
  end

  def new
    check_object_permissions!(@type, :create)
    
    @material = @type.new
  end

  def create
    check_object_permissions!(@type, :create)
    
    @material = @type.new(params[@type.to_s.underscore])
    
    if @material.save
      flash[:success] = material_translate(@type, :create_flash_success)

      #FIXME: Убрать ручную сборку урлов
      redirect_to url_for([:admin, @type.new]) + "?state=draft"
    else
      render_with_material :action => "new"
    end
  end
  
  def edit
    @material = @type.find(params[:id])
    
    check_object_permissions!(@material, :edit)
  end

  def update
    @material = @type.find(params[:id])
    
    check_object_permissions!(@material, :edit)
    
    if @material.update_attributes(params[@type.to_s.underscore])
      flash[:success] = material_translate(@type, :update_flash_success)

      #FIXME: Убрать ручную сборку урлов
      redirect_to url_for([:admin, @type.new]) + "?state=#{@material.state}"
    else
      render_with_material :action => "edit"
    end
  end
  
  def destroy
    @material = @type.find(params[:id])
    
    check_object_permissions!(@material, :delete)
    
    if @material.mark_deleted!
      flash[:success] = material_translate(@type, :delete_flash_success)
    else
      flash[:error] = material_translate(@type, :delete_flash_error)
    end
    
    redirect_to [:admin, @type.new]
  end
  
  def publicate
    @material = @type.find(params[:id])
    
    check_object_permissions!(@material, :publicate)
    
    if request.put?
      @type.transaction do
        @material.update_attributes(params[@type.to_s.underscore])
        
        @material.publicate! unless @material.publicated?
      end
      
      flash[:success] = material_translate(@type, :publicate_flash_success)

      respond_to do |format|
        format.js do
          #FIXME: Убрать ручную сборку урлов
          redirect_to url_for([:admin, @type.new]) + "?state=publicated"
        end
      end
    else
      render_with_material :action => "publicate", :layout => !request.xhr?
    end
  end
  
  def send_to_test
    @material = @type.find(params[:id])
    
    check_object_permissions!(@material, :send_to_test)
    
    @material.send_to_test!
    
    flash[:success] = material_translate(@type, :send_to_test_flash_success)

    #FIXME: Убрать ручную сборку урлов
    redirect_to url_for([:admin, @type.new]) + "?state=pending"
  end


  def upload_archive
    if request.post?
      if params[:archive]
        FileUtils.cp(
          params[:archive].path,
          File.join(Rails.configuration.idfix.parser_folder, "new", params[:upload_to],  File.basename(params[:archive].original_filename))
        )
        flash[:success] = ""[:materials_upload_archive_flash_success]
      else
        flash[:error] = ""[:materials_upload_archive_flash_error]
      end
    end
  end

  
  protected

  def render_with_material(options)
    scoped_options = options.dup
    scoped_options[:template] = "admin/#{@type.to_s.tableize}/#{scoped_options.delete(:action)}"

    begin
      render(scoped_options)
    rescue ActionView::MissingTemplate
      render(options)
    end
  end

  def material_translate(type, key, *args)
    text = ""[*args.dup.unshift("admin_#{type.to_s.tableize}_#{key}".to_sym)]
    text = ""[*args.dup.unshift("admin_materials_#{key}".to_sym)] if text.blank?

    return text
  end
  
  def assign_material_type
    @type = params[:material_type] ? params[:material_type].classify.constantize : Material
  end
  
  def filter_options
    @filter_options ||= {
      :state    => params[:state] || "publicated",

      :tag      => params[:tag_id],
      :section  => params[:section_id],
      :author   => params[:user_id],
      :date     => params[:date],
      :page     => params[:page]
    }
  end
end