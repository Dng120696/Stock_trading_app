class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname,:balance])
  end

  protected

  def after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      admin_dashboard_index_path
    elsif resource.is_a?(User)
      news_path
    else
      root_path
    end
  end

end
