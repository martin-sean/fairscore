include UserRatingMaths, TMDbApi

class MediaController < ApplicationController
  before_action :set_media, only: [:show]
  before_action :set_rating, only: [:show]
  before_action  :set_statuses

  # GET /media
  def index
    @title = 'Media List'
    ratings = Rating.all
    # Hash of media rating counts
    @counts = ratings.inject(Hash.new(0)) {|h, rating| h[rating.media_id] += 1; h }
    # Sort and paginate media IDs
    @media = Kaminari.paginate_array(sort_ratings(ratings, @counts).collect(&:media_id).uniq).page(params[:page]).per(Rating::PER_PAGE)
  end

  # GET /media/1
  def show
    @ratings = Rating.where(media_id: params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.s
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
    def sort_ratings(ratings, counts)
      # Sort alphabetically
      if params[:sort] == 'a-z'
        return ratings.sort_by {|r| get_media(r.media_id)['title']}
      # Sort by score
      elsif params[:sort] == 'score'
        return ratings.sort_by {|r| media_score(r.media_id).to_f || -1 }.reverse!
      # Sort by number of users
      elsif params[:sort] == 'users'
        return ratings.sort_by {|r| counts[r.media_id] }.reverse!
      # Sort by genre and set title
      elsif params[:genre].present?
        genre_name = get_genres['genres'].detect { |g| g['id'].to_s == params[:genre].to_s }['name']
        @title = "#{genre_name} Media"
        return ratings.select {|r| (get_media(r.media_id)['genres'].detect {|g| g['id'].to_s == params[:genre].to_s}).present? }
      end
      # Don't sort
      ratings
    end

end
