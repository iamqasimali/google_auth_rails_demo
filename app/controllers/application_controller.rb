class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  # def after_sign_in_path_for(resource_or_scope)
  #   # stored_location_for(resource_or_scope) || signed_in_root_path(resource_or_scope)
  #   if resource_or_scope.otp_required_for_login
  #      otp_code_two_factor_settings_path(resource_or_scope)
  #   else
  #     root_path(resource_or_scope)
  #   end
  # end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name,:last_name,:phone_number,:title,:country_id])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
  end

end
