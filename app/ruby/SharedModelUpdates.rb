module SharedModelUpdates

  # Update the sums of scores of a rating's user during rating updates/media deletions
  def update_user_sum_scores(rating, new_score, old_score)
    # Calculate the rating sums for the user and the new zscore rating
    new_rating_sum = rating.user.rating_sum + new_score.to_i - old_score.to_i
    new_rating_sum_of_squares = rating.user.rating_sum_of_squares + new_score.to_i**2 - old_score.to_i**2
    rating.user.update(rating_sum: new_rating_sum, rating_sum_of_squares: new_rating_sum_of_squares)
    [new_rating_sum, new_rating_sum_of_squares]
  end

  # Update z-scores for all other user ratings
  def update_rating_media_zscores(changed_rating)
    changed_rating.user.ratings.each do |rating|
      # Skip rating if it was the modified rating or the rating has no score
      next if rating.id == changed_rating.id || rating.score.blank?

      new_zscore = calc_z_score(rating.score.to_i, rating.user.rating_sum, rating.user.rating_sum_of_squares, rating.user.reload.scored_ratings)
      rating.media.zscore_sum += new_zscore - rating.zscore
      rating.zscore = new_zscore
      rating.media.save
      rating.save
    end
  end

end