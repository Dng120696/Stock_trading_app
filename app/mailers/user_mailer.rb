class UserMailer < ApplicationMailer
  default from: 'dongyang0016@gmail.com'
  def pending_email(user)
      @user = user
      mail(to: @user.email, subject: 'Registration Received')
  end

  def approved_email(user)
      @user = user
      mail(to: @user.email, subject: 'Registration Approved')
  end
end
