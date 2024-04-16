class Trader::DashboardController < ApplicationController

  def index
    if user_signed_in?
      portfolio_service = PortfolioService.new(current_user)
      @total_profit_loss, @total_gain_loss = portfolio_service.calculate_total_profit_loss_and_gain
      @total_portfolio = portfolio_service.calculate_total_portfolio_value
    end

    @top_stocks = Stock.get_top_stocks

    if params[:search].present?
      begin
        @stock = Stock.new_lookup(params[:search])
        if @stock.nil?
          flash.now[:alert] = 'Stock symbol not found'
        end

      rescue IEX::Errors::SymbolNotFoundError
        @stock = nil
      end
    end

    render 'trader/dashboard/index'
  end
end
