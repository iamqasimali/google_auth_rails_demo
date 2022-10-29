class User < ApplicationRecord
  devise :two_factor_authenticatable, :two_factor_backupable,
         otp_backup_code_length: 10, otp_number_of_backup_codes: 10,
         :otp_secret_encryption_key => ENV['OTP_SECRET_KEY']
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable,
         :recoverable, :rememberable, :validatable


  def qr_code_as_svg
    uri = two_factor_qr_code_uri
    RQRCode::QRCode.new(uri).as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 4,
      standalone: true
    ).html_safe
  end

  def two_factor_qr_code_uri
    issuer = ENV['OTP_2FA_ISSUER_NAME']
    label = [issuer, email].join(':')
    otp_provisioning_uri(label, issuer: issuer)
  end


  def generate_two_factor_secret_if_missing!
    return unless otp_secret.nil?
    self.update!(otp_secret: User.generate_otp_secret, otp_required_for_login: true)
  end

end


