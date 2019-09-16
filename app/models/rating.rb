class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :media
  belongs_to :status
end
