class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery with: :exception

  private
  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "users.edit.require_login"
    redirect_to login_path
  end
end
