class ApplicationController < ActionController::Base

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
