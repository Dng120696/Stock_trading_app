class AdminMailer < ApplicationMailer
  def new_user_notification(admin)
    @admin = admin
    mail(to: 'dongyang0016@gmail.com', subject: "New User Sign Up")
  end
end
