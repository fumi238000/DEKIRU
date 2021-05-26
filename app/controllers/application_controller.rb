class ApplicationController < ActionController::Base
  def redirect_root
    redirect_back(fallback_location: root_path) and return
  end
end
