class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionHelper

  MDB_API_KEY = Rails.application.credentials[:mdb][:api]
end
