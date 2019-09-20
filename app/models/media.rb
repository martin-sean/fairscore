class Media < ApplicationRecord
  has_many :ratings, dependent: :destroy
  has_many :users, through: :ratings
  has_many :genres
  has_many :actors
  has_one :director

  UPDATE_RATE = 30.minutes
  TEST_FAST_UPDATE_RATE = 10.seconds
end
