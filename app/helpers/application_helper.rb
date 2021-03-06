module ApplicationHelper
  def current_participant
    @current_participant
  end

  def current_registered_user?
    current_admin or current_examinator
  end

  def markdown(source)
    Kramdown::Document.new(source).to_html.html_safe
  end
end
