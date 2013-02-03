class ApplicationController < ActionController::Base
  include ApplicationHelper
  include HoptoadNotifier::Catcher if Object.const_defined?(:HoptoadNotifier)

  helper_method :render_to_string
  helper :all
  
  try_to_login

  if Object.const_defined?(:WillPaginate)
    # Fixing page number for pages with incorrect page number
    rescue_from WillPaginate::InvalidPage do
      redirect_to(:page => 1, :status => :moved_permanently)
    end
  end
end
