require 'open-uri'

module MovieDbAPI
  BASE_URL = 'https://api.themoviedb.org/3'
  MDB_API_KEY = Rails.application.credentials[:mdb][:api]

  # Return first page of movies for this year (2019)
  def get_new_movies
    url = BASE_URL + '/discover/movie?primary_release_year=2019&page=1&api_key=' + MDB_API_KEY
    JSON.parse(open(url).read)
  end

  # Return the top movies with at least 10000 votes
  def get_top_movies
    url = BASE_URL + '/discover/movie?sort_by=vote_average.desc&page=1&vote_count.gte=10000&api_key=' + MDB_API_KEY
    JSON.parse(open(url).read)
  end

  # Search movies
  def search_movies(query)
    url = BASE_URL + '/search/movie?query=' + query + '&api_key=' + MDB_API_KEY
    JSON.parse(open(url).read)
  end

end