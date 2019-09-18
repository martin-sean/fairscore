module MediaRatingMaths

  # Update the sums of scores of a rating's user during rating updates/media deletions
  def update_user_scores(rating, new_score, old_score)
    user = rating.user
    new_rating_sum = user.rating_sum + new_score - old_score
    new_rating_sum_of_squares = user.rating_sum_of_squares + new_score**2 - old_score**2
    user.update_attribute(:rating_sum, new_rating_sum)
    user.update_attribute(:rating_sum_of_squares, new_rating_sum_of_squares)
  end


  def calc_mean

  end

  def calc_std_dev

  end

  def calc_z_score
    
  end
end