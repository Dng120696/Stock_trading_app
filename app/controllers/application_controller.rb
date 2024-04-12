class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?


  def user_sign_in?
    user_signed_in? && current_user.present?
  end

  def admin_sign_in?
    admin_signed_in? && current_admin.present?
  end



  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname,:balance])
  end

  protected

  def after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      admin_dashboard_index_path
    elsif resource.is_a?(User)
      trader_dashboard_index_path
    else
      root_path
    end
  end

end
