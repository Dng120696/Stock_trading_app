class AdminMailer < ApplicationMailer
  def new_user_notification(user)
    @user = user
    mail(to: 'dongyang0016@gmail.com', subject: "New User Registration")
  end
end
