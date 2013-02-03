module Admin::BlogPostsHelper
  # Extending blocks
  def self.included(base)
    ActionView::Base.regions.append(:admin_menu, :blog_admin_menu_link)
  end

  def blog_admin_menu_link
    count = BlogPost.by_state(:publicated).count
    
    admin_menu_item(
      link_to(""[:admin_blog_posts_menu_link] + (count > 0 ? " (+#{count})" : ""),
        admin_blog_posts_path(:state => :publicated)
      ),
      params[:controller] == "admin/blog_posts"
    )
  end
end