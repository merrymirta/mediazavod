class Admin::UserArticlesController < ApplicationController
  require_login

  def index
    check_object_permissions!(UserArticle, :manage)

    @articles = UserArticle.latest.by_state(params[:state] || "draft").paginate(:page => params[:page])
  end

  def edit
    @article = UserArticle.find(params[:id])

    check_object_permissions!(@article, :manage)
  end

  def update
    @article = UserArticle.find(params[:id])

    check_object_permissions!(@article, :edit)

    if @article.update_attributes(params[:user_article])
      flash[:success] = ""[:admin_user_articles_update_flash_success]

      redirect_to [:admin, UserArticle.new]
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
    @article = UserArticle.find(params[:id])

    begin
      check_object_permissions!(@article, action)

      @article.send("#{action}!")

      render :action => "change_state"
    rescue Furwall::PermissionDenied
      render :text => ""
    end
  end
end