class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    extra_attrs = [:name, :birthday, :nationality, :gender]

    devise_parameter_sanitizer.permit(:sign_up, keys: extra_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: extra_attrs)
  end

  def require_admin
    redirect_to root_path, alert: "Not authorized" unless user_signed_in? && current_user.is_admin?
  end
end
