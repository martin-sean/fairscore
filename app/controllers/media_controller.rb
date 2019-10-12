include UserRatingMaths, TMDbApi

class MediaController < ApplicationController
  before_action :set_media, only: [:show]
  before_action :set_rating, only: [:show]
  before_action  :set_statuses

  # GET /media
  def index
    @title = 'Media List'
    @ratings = sorted_ratings
    check_genre_param
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

  # Sort results if param provided
  def sorted_ratings
    # Sort alphabetically
    if params[:sort] == 'a-z'
      return Kaminari.paginate_array(
          Rating.all.sort_by {|r| get_media(r.media_id)['title']}
          ).page(params[:page]).per(Rating::PER_PAGE)

    # Sort by score
    elsif params[:sort] == 'score'
      return Kaminari.paginate_array(
          Rating.all.sort_by {|r| media_score(r.media_id).to_f || -1 }.reverse!
          ).page(params[:page]).per(Rating::PER_PAGE)
    end
    Rating.page(params[:page])
  end

    # Filter results if genre provided
    def check_genre_param
      if params[:genre].present?
        @ratings = Kaminari.paginate_array(
            @ratings.select {|r| (get_media(r.media_id)['genres'].detect {|g| g['id'].to_s == params[:genre].to_s}).present? }
        ).page(params[:page]).per(Rating::PER_PAGE)
        genre_name = get_genres['genres'].detect { |g| g['id'].to_s == params[:genre].to_s }['name']
        @title = "#{genre_name} Media"
      end
    end

end
