module BlogPostsHelper
  def latest_blog_posts(options = {})
    options.reverse_merge!(
      :limit => 3
    )
    posts = BlogPost.latest.by_state([:featured]).all(:limit => options[:limit])

    render :partial => "blog_posts/latest", :locals => {:posts => posts, :options => options}
  end
end