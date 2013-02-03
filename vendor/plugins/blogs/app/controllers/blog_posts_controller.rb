class BlogPostsController < ApplicationController
  require_login :except => :show
  try_to_login :only => :show

  before_filter :assign_user

  def show
    @post = BlogPost.find(params[:id])

    #redirect_to blog_path(@post.author) unless object_permit?(@post, :view)
  end

  def drafts
    @posts = current_user.blog_posts.by_state("draft")
  end

  def new
    check_object_permissions!(BlogPost, :create)

    @post = BlogPost.new
  end

  def create
    check_object_permissions!(BlogPost, :create)

    @post = current_user.blog_posts.build(params[:blog_post])

    if @post.save
      flash[:success] = ""[:blog_posts_create_flash_success]

      redirect_to drafts_user_blog_posts_path(current_user)
    else
      render :action => :new
    end
  end

  def edit
    @post = BlogPost.find(params[:id])
  
    check_object_permissions!(@post, :edit)
  end

  def update
    @post = BlogPost.find(params[:id])

    check_object_permissions!(@post, :edit)

    if @post.update_attributes(params[:blog_post])
      flash[:success] = ""[:blog_posts_update_flash_success]

      redirect_to [current_user, @post]
    else
      render :action => :edit
    end
  end

  def publicate
    @post = BlogPost.find(params[:id])

    check_object_permissions!(@post, :publicate)

    @post.publicate!

    redirect_to [current_user, @post]
  end

  def destroy
    @post = BlogPost.find(params[:id])

    check_object_permissions!(@post, :delete)

    @post.mark_deleted!

    redirect_to blog_path(current_user)
  end

  protected

  def assign_user
    @user = parents.user
  end
end