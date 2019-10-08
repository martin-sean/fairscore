include TMDbAPI

class DiscoverController < ApplicationController
  before_action :set_media, only: [:new, :top, :search]

  # GET /discover/new
  def new
    @results = get_new_movies['results']
  end

  # GET /discover/top
  def top
    @results = get_top_movies['results']
  end

  # POST /discover/search
  def search
    @results = search_movies(params[:query])['results']
    puts 'hi'
  end

  # POST /discover/add
  def add_mdb_movie
    @media = Media.new(media_params)
    success = @media.save
    flash[success ? :info : :danger] = success ? 'Media was successfully added.' : 'Media could not be added.'
    redirect_back fallback_location: root_path
  end

  private
    def set_media
      @media = Media.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def media_params
      params.require(:media).permit(:id, :title, :year, :info)
    end
end
