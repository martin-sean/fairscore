require 'open-uri'
include ApplicationHelper

module TMDbApi
  BASE_URL = 'https://api.themoviedb.org/3'
  MDB_API_KEY = Rails.application.credentials[:mdb][:api]

  # Return Media for a given id
  def get_media(id)
    url = BASE_URL + '/movie/' + id.to_s + '?api_key=' + MDB_API_KEY
    JSON.parse(cached_media(id, 1, url))
  end

  # Return movies for this year
  def get_new_movies(page = 1)
    url = BASE_URL + '/discover/movie?primary_release_year='+ Time.current.year.to_s + '&page=' + page.to_s + '&api_key=' + MDB_API_KEY
    JSON.parse(cached_media('new-movies', page, url))
  end

  # Return the top movies with at least 10000 votes
  def get_top_movies(page = 1)
    url = BASE_URL + '/discover/movie?sort_by=vote_average.desc&vote_count.gte=4000&page=' + page.to_s + '&api_key=' + MDB_API_KEY
    JSON.parse(cached_media('top-movies', page, url))
  end

  def get_watched_movies(page = 1)
    url = BASE_URL + '/discover/movie?sort_by=vote_count.desc&page=' + page.to_s + '&api_key=' + MDB_API_KEY
    JSON.parse(cached_media('watched-movies', page, url))
  end

  def get_genre_movies(genres, page = 1)
    url = BASE_URL + '/discover/movie?sort_by=popular.desc&with_genres=' + genres + '&page=' + page + '&api_key=' + MDB_API_KEY
    JSON.parse(cached_media(genres, page, url))
  end

  # Search movies
  def search_movies(query, page = 1)
    url = BASE_URL + '/search/movie?query=' + query.to_s + '&page=' + page.to_s + '&api_key=' + MDB_API_KEY
    JSON.parse(open(url).read)
  end

  private

    # Retrieve result from cache and request an update if required
    def cached_media(id, page, url, time = 6.hours)
      cache_key = "media(#{id})-page(#{page})-TMDbAPI"
      cached_media = Rails.cache.read(cache_key)
      # If cache is blank immediately update the cache and await API
      if cached_media.blank?
        result = open(url).read
        Rails.cache.write(cache_key, {value: result, last_update: Time.current})
        cached_media = { value: result }
      # If cache is populated but needs refreshing
      elsif time_elapsed?(Time.current, cached_media[:last_update], time)
        ResultCacheUpdateJob.perform_later(url, cache_key)
      end
      cached_media[:value]
    end

end