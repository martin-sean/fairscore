module UserMediaRatingMaths

  # Update the sums of scores of a rating's user during rating updates/media deletions
  def update_user_scores(rating, new_score, old_score)
    user = rating.user
    new_rating_sum = user.rating_sum + new_score - old_score
    new_rating_sum_of_squares = user.rating_sum_of_squares + new_score**2 - old_score**2
    user.update_attribute(:rating_sum, new_rating_sum)
    user.update_attribute(:rating_sum_of_squares, new_rating_sum_of_squares)
  end

  # Calculate the mean given the sum and the count
  def calc_mean(sum, n)
    sum.fdiv(n)
  end

  # Calculate the standard deviation given the sum, squared sum and count
  def calc_std_dev(sum, sum_sq, n)
    Math.sqrt(sum_sq.fdiv(n) - calc_mean(sum, n)**2)
  end

  # Calculate the Z score given a value, the sum, the squared sum and count
  def calc_z_score(value, sum, sum_sq, n)
    (value - calc_mean(sum, n)).fdiv(calc_std_dev(sum, sum_sq, n))
  end
end