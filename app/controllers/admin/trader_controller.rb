class Admin::TraderController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :find_trader, only: [:show, :edit, :update,:destroy]

  def new
    @trader = User.new
  end

  def create
    @trader = User.new(trader_params)
    @trader.password = Rails.application.credentials.new_account[:password]
    @trader.skip_confirmation!
    @trader.status = 1

    if @trader.save
      UserMailer.admin_created_trader_acount(@trader).deliver_now
      redirect_to admin_trader_index_path, notice: "User created successfully."
    else
      render :new,alert: "User not created."
    end
  end

  def index
    @traders = User.where(status: :approved)
  end

  def show
  end

  def edit
  end

  def update
    if @trader.update(trader_params)
      if @trader.previous_changes.present?
        flash[:notice] = 'User details updated successfully.'
     else
       flash[:alert] = 'No Changes were made.'
     end
      redirect_to admin_trader_index_path
    else
      render :edit
    end
  end
  def destroy
    @trader.destroy
    redirect_to admin_trader_index_path, notice: "User deleted successfully."
  end
  private

  def find_trader
    @trader = User.find(params[:id])
  end

  def trader_params
    params.require(:user).permit(:firstname, :lastname, :email)
  end
end
