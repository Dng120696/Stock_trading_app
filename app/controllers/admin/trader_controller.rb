class Admin::TraderController < ApplicationController
    before_action :authenticate_admin_user!
    def create
      trader = User.new(trader_params)
      trader.password = Rails.application.credentials.trader.default_password
      trader.skip_confirmation!
      trader.status = 'approved'

      if trader.save
        WelcomeMailer
        redirect_to
      else
          render :new
      end
    end


    private
    
    def trader_params
      params.require(:trader).permit(:email, :firstname, :lastname)
    end
  end
  