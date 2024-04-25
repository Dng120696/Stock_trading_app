class UserMailer < ApplicationMailer
  default from:'stocktrader851@gmail.com'
  def newtrader_pending_email(user)
      @user = user
      mail(to: @user.email, subject: 'Welcome to Our Trading Community!')
  end

  def approved_email(user)
      @user = user
      mail(to: @user.email, subject: "Congratulations, #{@user.firstname} #{@user.lastname}!")
  end
  def otp_confirmation_email(user)
    @user = user
    mail(to: @user.email, subject: 'Confirm OTP for Adding Balance to your Account')
  end
  def notify_funds_added_success(user,amount)
    @user = user
    @amount = amount
    mail(to: @user.email, subject: 'Funds Successfully Added to Your Account')
  end
end
