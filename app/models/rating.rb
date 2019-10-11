class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :status

  PER_PAGE = 8

  # Tracked scored ratings count
  condition = proc {|rating| !rating.score.nil? ? 'scored_ratings' : nil}
  counter_culture [:user], column_name: condition, column_names: {['ratings.score = ?', 'user'] => 'scored_ratings' }

  # Range of valid scores
  MIN = 0
  MAX = 10

  paginates_per PER_PAGE
end
