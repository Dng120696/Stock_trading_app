class AdminMailer < ApplicationMailer
  def new_user_notification(user,admin)
    @admin = admin
    @user = user
    mail(to: 'stock.trader798@gmail.com', subject: "New User Sign Up")
  end
end
