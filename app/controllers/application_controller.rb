class ApplicationController < ActionController::Base
  # Rescue 404s to dynamic page unless in development
  unless Rails.application.config.consider_all_requests_local
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActionController::UnknownAction, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end

  def render_404
    if /(jpe?g|png|gif)/i === request.path
      render text: "404 Not Found", status: 404
    else
      render template: "static_pages/error_404", layout: 'application', status: 404
    end
  end

  protect_from_forgery

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  protected

  def logged_in?
    unless session[:user_id]
      session[:return_to] = request.fullpath
      redirect_to log_in_path, alert: 'Whoa! You need to log in to do that.'
      return false
    else
      return true
    end
  end
end
