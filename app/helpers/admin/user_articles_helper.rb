module Admin::UserArticlesHelper
  # Extending blocks
  def self.included(base)
    ActionView::Base.regions.append(:admin_menu, :user_article_admin_menu_link)
  end

  def user_article_admin_menu_link
    count = UserArticle.by_state(:draft).count
    
    admin_menu_item(
      link_to(""[:admin_user_articles_menu_link] + (count > 0 ? " (+#{count})" : ""),
        admin_user_articles_path(:state => :draft)
      ),
      params[:controller] == "admin/user_articles"
    )
  end
end