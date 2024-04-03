class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin_user!
  def index
    @users = User.all.order(:id)
  end
  def approve
    trader = User.find(params[:id])
    trader.update(status: :approved)
    UserMailer.approved_email(trader).deliver_now
    redirect_to admin_dashboard_path, notice: "Trader account approved"
  end
end
