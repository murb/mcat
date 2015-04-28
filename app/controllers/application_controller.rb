class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :current_participant

  def current_participant
    @current_participant ||= Participant.find_by(session: session.id)
  end
end
