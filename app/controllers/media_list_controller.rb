include TMDbApi

class MediaListController < ApplicationController

  before_action :set_ratings
  before_action :set_statuses

  # GET /medialist
  def index
    sort_ratings
  end

  private
    def set_ratings
      if params[:status]
        @status_ratings =  { params[:status].to_i => current_user.ratings.where(status_id: params[:status]) }
      else
        @status_ratings = current_user.ratings.group_by(&:status_id)
      end
    end

    def set_statuses
      @statuses = Rails.cache.fetch('statuses') do
        Status.all.to_a
      end
    end

    # Sort the ratings
    def sort_ratings
      # Sort alphabetically
      if params[:sort] == 'a-z'
        @status_ratings.each do |index, ratings|
          @status_ratings[index] = ratings.sort_by { |r| get_media(r.media_id)['title'] }
        end
      # Sort by rating
      elsif params[:sort] == 'score'
        @status_ratings.each do |index, ratings|
          @status_ratings[index] = ratings.sort_by { |r| r.score || -1 }.reverse! # Unrated at the bottom (-1)
        end
      end
    end

end
