class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin_user!

  def index
    @users = User.where(status: :pending).all.order(:id)
  end
  def approve
    @trader = User.find(params[:id])

    if @trader&.update(status: :approved)
      UserMailer.approved_email(@trader).deliver_now
      Notification.create(user: @trader, message: "Your account has been approved")
      ActionCable.server.broadcast "notifications_channel",{message: message_render(@trader)}
      redirect_to admin_dashboard_index_path, notice: "Trader account approved successfully"
    else
      redirect_to admin_dashboard_index_path, alert: "Failed to approve trader account"
    end

  end

  private
  def message_render(trader)
    render(partial:'notification',locals:{message: trader})
end
end
