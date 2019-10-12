class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from OpenURI::HTTPError, with: :api_error
  protect_from_forgery with: :exception
  include SessionHelper

  # Rescue wrong record ids
  def record_not_found
    flash[:error] = 'An Error occurred: URL was not valid, record was not found'
    redirect_to root_path
  end

  # Error occurred during API call
  def api_error
    flash[:error] = 'An Error occurred: Media does not exist on TMDb'
    redirect_to root_path
  end

end
