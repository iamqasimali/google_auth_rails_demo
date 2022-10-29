class HomeController < ApplicationController
  def index
  end

  def profile

  end

  def settings


  end

  def show_modal
    codes = ["fe860c18f2", "f59b349fea", "63ca06681d", "248b80ebfa", "38b0509bf4", "aac7c059ab", "358d23289c", "159c0e5a19", "bc971417f0", "2824ea6ec2"]
    uri = current_user.two_factor_qr_code_uri
    qr_code = current_user.qr_code_as_svg(uri)
    otp_secret = current_user.otp_secret || "AOXJE44F5TEXXG66BSA2HZTR"
    respond_to do |format|
      format.js { render :partial => 'home/load_qr_data',:locals => {codes: codes, otp_secret: otp_secret, qr_code: qr_code } }
    end

  end
end
