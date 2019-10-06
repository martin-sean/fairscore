require 'open-uri'

module MovieDbAPI
  BASE_URL = 'https://api.themoviedb.org/3'
  MDB_API_KEY = Rails.application.credentials[:mdb][:api]

  def get_new_movies
    url = BASE_URL + '/discover/movie?primary_release_year=2019&page=1&api_key=' + MDB_API_KEY
    JSON.parse(open(url).read)
  end

  def get_top_movies
    url = BASE_URL + '/discover/movie?sort_by=vote_average.desc&page=1&vote_count.gte=10000&api_key=' + MDB_API_KEY
    JSON.parse(open(url).read)
  end

end