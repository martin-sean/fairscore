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

  # Get the score for a given media from cache or recalculate
  def media_score(media_id)
    cache_key = 'media-' + media_id.to_s
    score = Rails.cache.read(cache_key)
    # Check if score cache needs updating
    if score.blank? || Time.now - score[:last_update] > 5.minutes
      MediaScoreUpdateJob.perform_later(media_id, cache_key)
    end
    score.present? ? format_score(score[:value]) : 'No score yet'
  end

  # Return the year from the date in the format of YYYY-MM-DD (From TMDb)
  def year_from_date(string)
    return unless string.present?
    Date.strptime(string, '%Y-%m-%d').year
  end

  private

    # Format the score to display in view
    def format_score(score)
      'Score: %.2f' % calculate_standard_score(score) + ' / 10'
    end

    # Roughly fit Z-score to normal distribution with a mean of 5 and a standard deviation of 1.5
    def calculate_standard_score(score)
      std_dev = 1.5
      mean = 5
      (score * std_dev) + mean
    end

end
