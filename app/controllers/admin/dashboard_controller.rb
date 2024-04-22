class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin_user!

  def index
    @users = User.where(status: :pending).order(:id)
  end
  def approve
    trader = User.find(params[:id])

    if trader&.update(status: :approved)
      UserMailer.approved_email(trader).deliver_now
      ActionCable.server.broadcast("trader_channel_#{trader.id}", {message: "Your Account has been approved."})
      redirect_to admin_dashboard_path, notice: "Trader account approved successfully"
    else
      redirect_to admin_dashboard_path, alert: "Failed to approve trader account"
    end

  end
end
