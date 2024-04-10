class Admin::TraderController < ApplicationController
  def new
    @trader = User.new
  end

  def create
    @trader = User.new(trader_params)
    @trader.password = Rails.application.credentials.trader.default_password
    @trader.skip_confirmation!
    @trader.status = 'approved'


    if @trader.save
      redirect_to new_admin_trader_path, notice: "User created successfully."
    else
      render :new
    end
  end

  private

  def trader_params
    params.require(:trader).permit(:email, :password, :password_confirmation)
  end
end
