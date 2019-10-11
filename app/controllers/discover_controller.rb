include TMDbApi

class DiscoverController < ApplicationController
  before_action :set_user_ratings
  before_action :set_page

  # GET /discover
  def index
  end

  # POST /discover/search
  def search
    @results = search_movies(params[:query], params[:page])
    @title = 'Search'
  end

  private

    # Read the params and initialise the page
    def set_page
      browse = params[:browse]
      page = params[:page]
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
