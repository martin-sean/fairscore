module StatisticsHelper

  # Calculate the mean rating score. TODO If I wasn't so lazy, I would cache this value, or use a rolling mean
  def calculate_global_mean
    score_sum = 0
    count = 0
    @ratings.each do |rating|
      if rating.score.present?
        score_sum += rating.score
        count += 1
      end
    end
    score_sum.fdiv(count)
  end

end

