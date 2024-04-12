class Admin::TraderController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :find_trader, only: [:show, :edit, :update]

  def new
    @trader = User.new
  end

  def create
    @trader = User.new(trader_params)
    @trader.password = 'password123'
    @trader.balance = 20000
    @trader.skip_confirmation!
    @trader.status = 1

    if @trader.save
      # UserMailer.newtrader_pending_email(@trader).deliver_now
      # UserMailer.approved_email(@trader).deliver_now
      redirect_to admin_trader_index_path, notice: "User created successfully."
    else
      render :new,alert: "User not created."
    end
  end

  def index
    @traders = User.all
  end

  def show
  end

  def edit
  end

  def update
    if @trader.update(trader_params)
      redirect_to admin_trader_path(@trader), notice: "User details updated successfully."
    else
      render :edit
    end
  end

  private

  def find_trader
    @trader = User.find(params[:id])
  end

  def trader_params
    params.require(:user).permit(:firstname, :lastname, :email)
  end
end
