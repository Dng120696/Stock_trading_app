class UserMailer < ApplicationMailer
  default from:'stocktrader851@gmail.com'
  def newtrader_pending_email(user)
      @user = user
      mail(to: @user.email, subject: 'Welcome to Our Trading Community!')
  end

  def admin_created_trader_acount(user)
      @user = user
      mail(to: @user.email, subject: "Congratulations, #{@user.firstname} #{@user.lastname}!")
  end
  def approved_email(user)
      @user = user
      mail(to: @user.email, subject: "Congratulations, #{@user.firstname} #{@user.lastname}!")
  end
  def otp_confirmation_email(user)
    @user = user
    mail(to: @user.email, subject: 'Confirm OTP to your Account')
  end
  def notify_funds_success(user,amount,type)
    @user = user
    @amount = amount
    @type = type
    mail(to: @user.email, subject: 'Funds Successfully Processed')
  end
end
