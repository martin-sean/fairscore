class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :media
  has_one :status
end
