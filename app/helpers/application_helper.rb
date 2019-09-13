module ApplicationHelper

  # Format page title
  def full_title(page_title)
    title = 'Course App'
    if page_title.empty?
      title
    else
      "#{page_title} | #{title}"
    end
  end

  # Convert flash type between rails and bootstrap
  def flash_message_type(type)
    case type
    when 'success'
      "alert-success"
    when 'error'
      "alert-danger"
    when 'alert'
      "alert-warning"
    when 'notice'
      "alert-primary"
    else
      "alert-" + type.to_s
    end
  end

end
