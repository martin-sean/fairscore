module ApplicationHelper

  # Format page title
  def full_title(page_title)
    title = 'Course App'
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

end
