include UserRatingMaths, TMDbApi

class MediaController < ApplicationController
  before_action :set_media, only: [:show]
  before_action :set_rating, only: [:show]
  before_action  :set_statuses

  # GET /media
  def index
    @ratings = Rating.order(:media.name).page(params[:page])
    @media_ids = @ratings.collect(&:media_id)
    @counts = @ratings.inject(Hash.new(0)) {|h, rating| h[rating.media_id] += 1; h }
  end

  # GET /media/1
  def show
    @ratings = Rating.where(media_id: params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_media
      @media = get_media(params[:id])
    end

    def set_rating
      @rating = Rating.find_by(media_id: params[:id], user_id: current_user)
    end

    def set_statuses
      @statuses = Rails.cache.fetch('statuses') do
        Status.all.to_a
      end
    end

end
