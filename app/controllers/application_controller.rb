class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    redirect_to login_path, alert: "Please log in" unless current_user
  end

  def require_admin
    redirect_to root_path, alert: "Not authorized" unless current_user&.is_admin?
  end
end
