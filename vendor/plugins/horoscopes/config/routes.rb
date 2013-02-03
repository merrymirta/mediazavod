module Idfix
  module Horoscopes
    module Routes
      def horoscopes_routes
        horoscopes "horoscopes", :controller => "horoscopes"
      end
    end
  end
end

ActionController::Routing::RouteSet::Mapper.send(:include, Idfix::Horoscopes::Routes)