include TMDbApi

class DiscoverController < ApplicationController
  before_action :require_login
  before_action :set_user_ratings
  before_action :set_page

  # GET /discover
  def index
  end

  private

    # Read the params and initialise the page
    def set_page
      search = params[:search]
      genre = params[:genre]
      browse = params[:browse]
      page = params[:page]

      if search.present?
        @results = search_movies(search, page)
        @title = "Results for '#{search}'"
        return
      end

      if genre.present?
        @results = get_genre_movies(genre, page)
        genre_name = get_genres['genres'].detect { |g| g['id'].to_i == genre.to_i }['name']
        @title = "#{genre_name} Media"
        return
      end

      case browse
      when 'top'
        @results = get_top_movies(page)
        @title = 'Top Media'
      when 'watched'
        @results = get_watched_movies(page)
        @title = 'Most Watched'
      else
        @results = get_new_movies(page)
        @title = 'Recent Media'
      end
    end

    def set_user_ratings
      @ratings = current_user.ratings
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def media_params
      params.require(:media).permit(:id, :title, :year, :info)
    end

end
