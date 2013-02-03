class BlogsController < ApplicationController
  layout :get_layout

  require_login :only => :my

  def show
    @user = User.find_by_remote_id(params[:id])
    
    @posts = @user.blog_posts.latest.visible.paginate(:page => params[:page])
  end

  def my
    @user = current_user
    @posts = @user.blog_posts.latest.visible.paginate(:page => params[:page])

    render :action => :show
  end

  def index
    @users = User.paginate(
      :joins => :blog_posts,
      :order => "blog_posts.created_at DESC",
      :group => "users.id",
      :page => params[:page],
      :per_page => 10
    )
  end

  protected

  def get_layout
    %w{show my}.include?(params[:action]) ? "blog_posts" : "_blogs"
  end
end