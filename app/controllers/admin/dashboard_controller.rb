class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin_user!

  def index
    @users = User.where(status: :pending).all.order(:id)
  end
  def approve
    @trader = User.find(params[:id])

    if @trader&.update(status: :approved)
      UserMailer.approved_email(@trader).deliver_now
      @notifications = Notification.create(user: @trader, message: "Your account has been approved")
      ActionCable.server.broadcast "notifications_channel",{notification: message_render(@notifications)}

    else
      redirect_to admin_dashboard_index_path, alert: "Failed to approve trader account"
    end

  end

  private
  def message_render( notification)
    render(partial:'notifications/notification',locals:{notification:  notification})
end
end
