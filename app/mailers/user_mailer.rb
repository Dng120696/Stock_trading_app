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
end
