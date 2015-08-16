class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :current_participant

  def current_participant
    @current_participant ||= Participant.find_by(session: session.id)
  end

  def signout
    sign_out
    redirect_to root_path
  end

  def require_admin!
    redirect_to new_admin_session_path, notice: "U dient administrator te zijn om nieuwe accounts aan te maken" if current_admin.nil?
  end

  def require_admin_or_examinator!
    redirect_to root_path, notice: "U dient ingelogd te zijn als administrator of examinator." unless (current_admin or current_examinator)
  end

  def home

  end

  def docs

  end
end
