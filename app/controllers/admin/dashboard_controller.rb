class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin_user!

  def index
    @users = User.where(status: :pending).order(:id)
  end
  def approve
    trader = User.find(params[:id])

    if trader&.update(status: :approved)
      UserMailer.approved_email(trader).deliver_now
      redirect_to admin_dashboard_path, notice: "Trader account approved successfully"
    else
      redirect_to admin_dashboard_path, alert: "Failed to approve trader account"
    end

  end
end
