module UserMediaRatingMaths

  # Calculate the mean given the sum and the count
  def calc_mean(sum, n)
    n > 0 ? sum.fdiv(n) : 0 # Return 0 if n is not a positive integer
  end

  # Calculate the standard deviation given the sum, squared sum and count
  def calc_std_dev(sum, sum_sq, n)
    n > 0 ? Math.sqrt(calc_mean(sum_sq, n) - calc_mean(sum, n)**2) : 0 # Return 0 if n is not a positive integer
  end

  # Calculate the Z score given a value, the sum, the squared sum and count
  def calc_z_score(value, sum, sum_sq, n)
    std_dev = calc_std_dev(sum, sum_sq, n)
    mean = calc_mean(sum, n)
    std_dev != 0 ? (value - mean).fdiv(std_dev) : 0 # Don't evaluate if the std dev is 0
  end
end