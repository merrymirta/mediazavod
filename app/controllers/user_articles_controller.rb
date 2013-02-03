class UserArticlesController < ApplicationController
  require_login :except => [:index, :show]

  def index
    @articles = UserArticle.latest.visible.paginate(:page => params[:page])
  end
  
  def show
    @article = UserArticle.find(params[:id])
  end

  def new
    @article = UserArticle.new
  end

  def create
    @article = current_user.user_articles.build(params[:user_article])

    if @article.save
      flash[:success] = ""[:user_articles_create_flash_success]

      redirect_to @article
    else
      render :action => :new
    end
  end

  def edit
    @article = current_user.user_articles.find(params[:id])
  end

  def update
    @article = current_user.user_articles.find(params[:id])

    if @article.update_attributes(params[:user_article])
      flash[:success] = ""[:user_articles_update_flash_success]

      redirect_to @article
    else
      render :action => :edit
    end
  end

  def destroy
    @article = current_user.user_articles.find(params[:id])

    check_object_permissions!(@article, :delete)

    @article.mark_deleted!

    redirect_to user_articles_path
  end
end
