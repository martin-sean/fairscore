class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :media
  belongs_to :status

  # Tracked scored ratings count
  condition = proc {|rating| !rating.score.nil? ? 'scored_ratings' : nil}
  counter_culture [:media], column_name: condition, column_names: {['ratings.score = ?', 'media'] => 'scored_ratings'}
  counter_culture [:user], column_name: condition, column_names: {['ratings.score = ?', 'user'] => 'scored_ratings' }

  # Range of valid scores
  MIN = 0
  MAX = 10
end
