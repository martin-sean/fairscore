require 'open-uri'
include ApplicationHelper

module TMDbApi
  BASE_URL = 'https://api.themoviedb.org/3'
  MDB_API_KEY = Rails.application.credentials[:mdb][:api]

  # Return Media for a given id
  def get_media(id)
    url = BASE_URL + '/movie/' + id.to_s + '?api_key=' + MDB_API_KEY
    JSON.parse(cached_media(id, page, url))
  end

  # Return first page of movies for this year (2019)
  def get_new_movies(page = 1)
    url = BASE_URL + '/discover/movie?primary_release_year=2019&page=' + page.to_s + '&api_key=' + MDB_API_KEY
    JSON.parse(cached_media('new-movies', page, url))
  end

  # Return the top movies with at least 10000 votes
  def get_top_movies(page = 1)
    url = BASE_URL + '/discover/movie?sort_by=vote_average.desc&page=1&vote_count.gte=10000&page=' + page.to_s + '&api_key=' + MDB_API_KEY
    JSON.parse(cached_media('top-movies', page, url))
  end

  # Search movies
  def search_movies(query, page = 1)
    url = BASE_URL + '/search/movie?query=' + query.to_s + '&page=' + page.to_s + '&api_key=' + MDB_API_KEY
    JSON.parse(open(url).read)
  end

  private

    # Retrieve result from cache and request an update if required
    def cached_media(id, page, url)
      cache_key = "media(#{id})-page(#{page})-TMDbAPI"
      cached_media = Rails.cache.read(cache_key)
      # If cache is blank immediately update the cache and await API
      if cached_media.blank?
        result = open(url).read
        Rails.cache.write(cache_key, {value: result, last_update: Time.now})
        cached_media = { value: result }
      # If cache is populated but needs refreshing
      elsif time_elapsed?(Time.now, cached_media[:last_update], 6.hours)
        ResultCacheUpdateJob.perform_later(url, cache_key)
      end
      cached_media[:value]
    end

end