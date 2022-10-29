class TwoFactorSettingsController < ApplicationController

  def new
    # binding.pry
    if current_user.otp_required_for_login
      flash[:alert] = 'Two Factor Authentication is already enabled.'
      return redirect_to edit_user_registration_path

      respond_to do |format|
        format.js { render :partial => 'home/load_qr_data',:locals => {error: flash[:alert] } }
      end
    else
      # binding.pry
      current_user.generate_two_factor_secret_if_missing!
      codes =   current_user.generate_otp_backup_codes!
      current_user.save
      qr_code = current_user.qr_code_as_svg
      otp_secret = current_user.otp_secret
      respond_to do |format|
        format.js { render :partial => 'home/load_qr_data',:locals => {codes: codes, otp_secret: otp_secret, qr_code: qr_code } }
      end
    end
  end

  def otp_code
    # binding.pry
  end

  def verify_otp
    binding.pry
    if current_user.validate_and_consume_otp! enable_2fa_params_code[:code]
      backup_codes = current_user.generate_otp_backup_codes!
      current_user.save!
      session[:codes] = backup_codes
      if signed_in?(resource_name)
        path = memberships_path(resource)
      else
        path = new_session_path(resource_name)
      end
      redirect_to path
    else
      flash[:danger] = "OTP Code invalid. Please try again"
      redirect_to otp_code_two_factor_settings_path
    end
  end

  private

  def enable_2fa_params_code
    params.require(:two_fa).permit(:code)
  end

end
