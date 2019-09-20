include UserMediaRatingMaths

class MediaUpdateJob < ApplicationJob
  queue_as :default

  # Update the mean of a media after a user score update
  def perform(media)
    zscore_sum = nil
    count = 0 # Count the non-nil ratings
    media.ratings.each do |rating|
      next if rating.score.nil? # Skip nil ratings
      zscore_sum = 0 if zscore_sum.nil? # Set
      user = rating.user
      zscore_sum += calc_z_score(rating.score, user.rating_sum, user.rating_sum_of_squares, user.scored_ratings)
      count += 1
    end
    media.update_attribute(:zscore, zscore_sum.present? ? zscore_sum.fdiv(count) : nil)
  end
end
