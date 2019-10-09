class MediaListController < ApplicationController

  before_action :set_ratings, only: [:index]
  before_action :set_statuses, only: [:index]

  # GET /medialist
  def index
  end

  private
    def set_ratings
      @status_ratings = current_user.ratings.group_by(&:status_id)
    end

    def set_statuses
      @statuses = Rails.cache.fetch('statuses') do
        Status.all.to_a
      end
    end
end
