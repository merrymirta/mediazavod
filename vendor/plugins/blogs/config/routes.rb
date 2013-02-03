module Idfix
  module Routes
    module Blogs
      def self.included(base)
        base.alias_method_chain(:admin_routes, :blog_routes)
      end

      def has_blog(*arguments)
        raise "Blog posts must be connected to parent resource" unless arguments.any?

        with_options arguments.first do |r|
          r.resources :blog_posts, 
            :collection => {
              :drafts     => :get
            },
            :member => {
              :publicate  => :post
            }
        end
      end

      def admin_routes_with_blog_routes(*args)
        admin_routes_without_blog_routes(*args)

        with_options(args.first) do |admin|
          admin.resources :blog_posts,
            :member => {
              :approve => :post,
              :decline => :post,
              :feature => :post
            }
        end
      end

      def blog_routes
        resources :blogs, :collection => {:my => :any}
        
        resources :blog_posts do |post|
          post.has_comments
          post.has_pictures
        end
      end
    end
  end
end

ActionController::Routing::RouteSet::Mapper.send(:include, Idfix::Routes::Blogs)