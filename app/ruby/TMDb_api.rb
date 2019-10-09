require 'open-uri'
include ApplicationHelper

module TMDbApi
  BASE_URL = 'https://api.themoviedb.org/3'
  MDB_API_KEY = Rails.application.credentials[:mdb][:api]

  # Return Media for a given id
  def get_media(id)
    url = BASE_URL + '/movie/' + id.to_s + '?api_key=' + MDB_API_KEY
    JSON.parse(cached_media(id, url))
  end

  # Return first page of movies for this year (2019)
  def get_new_movies
    url = BASE_URL + '/discover/movie?primary_release_year=2019&page=1&api_key=' + MDB_API_KEY
    JSON.parse(cached_media('new-movies', url))
  end

  # Return the top movies with at least 10000 votes
  def get_top_movies
    url = BASE_URL + '/discover/movie?sort_by=vote_average.desc&page=1&vote_count.gte=10000&api_key=' + MDB_API_KEY
    JSON.parse(cached_media('top-movies', url))
  end

  # Search movies
  def search_movies(query)
    url = BASE_URL + '/search/movie?query=' + query.to_s + '&api_key=' + MDB_API_KEY
    JSON.parse(open(url).read)
  end

  private

    # Retrieve result from cache and request an update if required
    def cached_media(id, url)
      cache_key = "media-#{id}-TMDbAPI"
      cached_media = Rails.cache.read(cache_key)
      # Check if update is required
      if cached_media.blank? || time_elapsed?(Time.now, cached_media[:last_update], 6.hours)
        ResultCacheUpdateJob.perform_later(url, cache_key)
      end
      # If data not cached, return an empty result
      cached_media.present? ? cached_media[:value] : '{"results": []}'
    end

end