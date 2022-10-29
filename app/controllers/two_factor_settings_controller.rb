class TwoFactorSettingsController < ApplicationController

def new
  binding.pry
  if current_user.otp_required_for_login
    flash[:alert] = 'Two Factor Authentication is already enabled.'
    return redirect_to edit_user_registration_path

    respond_to do |format|
      format.js { render :partial => 'home/load_qr_data',:locals => {error: flash[:alert] } }
    end
  else
    binding.pry
    current_user.generate_two_factor_secret_if_missing!
    codes = ["fe860c18f2", "f59b349fea", "63ca06681d", "248b80ebfa", "38b0509bf4", "aac7c059ab", "358d23289c", "159c0e5a19", "bc971417f0", "2824ea6ec2"]
    uri = current_user.two_factor_qr_code_uri
    qr_code = current_user.qr_code_as_svg(uri)
    otp_secret = current_user.otp_secret || "AOXJE44F5TEXXG66BSA2HZTR"
    binding.pry
    respond_to do |format|
      format.js { render :partial => 'home/load_qr_data',:locals => {codes: codes, otp_secret: otp_secret, qr_code: qr_code } }
    end
  end

end


  def verify_otp
    if current_user.validate_and_consume_otp! enable_2fa_params_code[:code]
      backup_codes = current_user.generate_otp_backup_codes!
      current_user.save!
      session[:codes] = backup_codes
      redirect_to two_factor_setting_path(current_user)
    else
      flash[:danger] = "OTP Code invalid. Please try again"
      redirect_to new_two_factor_setting_path
    end
  end

  private

  def enable_2fa_params_code
    params.require(:two_fa).permit(:code)
  end

end
