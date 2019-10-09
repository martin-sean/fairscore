module SharedModelUpdates

  # Update the sums of scores of a rating's user during rating updates/media deletions
  def update_user_sum_scores(rating, new_score, old_score)
    # Calculate the rating sums for the user and the new zscore rating
    new_rating_sum = rating.user.rating_sum + new_score.to_i - old_score.to_i
    new_rating_sum_of_squares = rating.user.rating_sum_of_squares + new_score.to_i**2 - old_score.to_i**2
    rating.user.update(rating_sum: new_rating_sum, rating_sum_of_squares: new_rating_sum_of_squares)
    [new_rating_sum, new_rating_sum_of_squares]
  end

  # Start a new job to update the zscores related to a given rating that was changed.
  # Jobs use FIFO queue to prevent data loss from multiple requests
  def update_rating_media_zscores(changed_rating)
    MediaZscoresUpdateJob.perform_later(changed_rating)
  end

end