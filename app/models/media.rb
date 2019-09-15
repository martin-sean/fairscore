class Media < ApplicationRecord
  has_many :ratings, dependent: :destroy
  has_many :users, through: :ratings
  has_many :genres
  has_many :actors
  has_one :director
end
