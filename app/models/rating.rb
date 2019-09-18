class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :media
  belongs_to :status

  # Range of valid scores
  MIN = 0
  MAX = 10
end
