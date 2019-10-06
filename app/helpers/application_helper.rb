module ApplicationHelper

  # Format page title
  def full_title(page_title)
    title = 'Fairscore'
    if page_title.empty?
      title
    else
      "#{page_title} · #{title}"
    end
  end

  # Convert flash type between rails and bootstrap
  def flash_message_type(type)
    messages = { 'success' => 'success', 'error' => 'danger', 'alert' => 'warning', 'notice' => 'primary' }
    'alert-' + (messages[type].present? ? messages[type] : type)
  end

  # Format the score for a given media
  def get_media_score(media)
    return 'No score yet' if media.blank? || media.scored_ratings == 0
    "%.2f" % calculate_standard_score(media) + ' / 10'
  end

  # Roughly fit Z-score to normal distribution with a mean of 5 and a standard deviation of 2
  def calculate_standard_score(media)
    std_dev = 1.5
    mean = 5
    (media.zscore_sum / media.scored_ratings * std_dev) + mean
  end

  def get_year_from_date(string)
    Date.strptime(string, '%Y-%m-%d').year
  end

end
