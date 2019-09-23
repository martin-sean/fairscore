include UserMediaRatingMaths

class MediaUpdateJob < ApplicationJob
  queue_as :default

  # Update the mean of a media after a user score update
  def perform(media, old_score, new_score)
    media.zscore_sum += new_score.to_i - old_score.to_i
    media.save
  end
end
