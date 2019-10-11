include UserRatingMaths

class MediaScoreUpdateJob < ApplicationJob
  queue_as :default

  # Write the average zscore of a media to cache
  def perform(media_id, cache_key)
    @ratings = Rating.where(media_id: media_id)
    zscore_sum = 0
    scored_count = 0
    # Sum the zscores and count the scored ratings
    @ratings.each do |rating|
      if rating.score.present?
        zscore_sum += rating.zscore
        scored_count += 1
      end
    end
    score = zscore_sum.fdiv(scored_count)
    Rails.cache.write(cache_key, { value: score, last_update: Time.current }) unless score.nan?
  end

end
