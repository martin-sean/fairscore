class HomeController < ApplicationController
  def index
  end

  # Handle errors semi-gracefully
  # GET /home/not_found
  def not_found
    flash[:error] = 'The page you tried to visit was not valid'
    redirect_to root_path
  end

end
