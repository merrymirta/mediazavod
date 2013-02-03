class Admin::BlogPostsController < ApplicationController
  require_login

  def index
    check_object_permissions!(BlogPost, :manage)

    @posts = BlogPost.latest.by_state(params[:state] || "publicated").paginate(:page => params[:page])
  end

  def edit
    @post = BlogPost.find(params[:id])

    check_object_permissions!(@post, :manage)
  end

  def update
    @post = BlogPost.find(params[:id])

    check_object_permissions!(@post, :edit)

    if @post.update_attributes(params[:blog_post])
      flash[:success] = ""[:admin_blog_posts_update_flash_success]

      redirect_to [:admin, BlogPost.new]
    else
      render :action => :edit
    end
  end

  def approve
    change_state(:approve)
  end

  def decline
    change_state(:decline)
  end

  def feature
    change_state(:feature)
  end

  protected

  def change_state(action)
    @post = BlogPost.find(params[:id])

    begin
      check_object_permissions!(@post, action)

      @post.send("#{action}!")

      render :action => "change_state"
    rescue Furwall::PermissionDenied
      render :text => ""
    end
  end
end