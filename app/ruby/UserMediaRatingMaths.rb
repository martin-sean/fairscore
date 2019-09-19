module UserMediaRatingMaths

  # Update the sums of scores of a rating's user during rating updates/media deletions
  def update_user_scores(rating, new_score, old_score)
    user = rating.user
    new_rating_sum = user.rating_sum + new_score - old_score
    new_rating_sum_of_squares = user.rating_sum_of_squares + new_score**2 - old_score**2
    user.update_attribute(:rating_sum, new_rating_sum)
    user.update_attribute(:rating_sum_of_squares, new_rating_sum_of_squares)
  end

  # Update the mean of a media after a user score update
  def update_media_mean_score(media)
    z_score_sum = 0
    media.ratings.each do |rating|
      user = rating.user
      z_score_sum += calc_z_score(rating.score, user.rating_sum, user.rating_sum_of_squares, user.ratings.len)
    end
    z_score = z_score_sum.fdiv(media.ratings.len)
    media.update_attribute(:z_score, z_score)
  end

  # Calculate the mean given the sum and the count
  def calc_mean(sum, n)
    sum.fdiv(n)
  end

  # Calculate the standard deviation given the sum, squared sum and count
  def calc_std_dev(sum, sum_sq, n)
    sum_sq.fdiv(n) - calc_mean(sum, n)
  end

  # Calculate the Z score given a value, the sum, the squared sum and count
  def calc_z_score(value, sum, sum_sq, n)
    (value - calc_mean(sum, n)).fdiv(Math.sqrt(calc_std_dev(sum, sum_sq, n)))
  end
end