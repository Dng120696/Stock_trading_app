class Trader::DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def search_symbol
    session[:search_symbol] = params[:search]
    redirect_to trader_dashboard_index_path
  end

  def index_load
    portfolio_service = PortfolioService.new(current_user)
    @total_profit_loss, @total_gain_loss = portfolio_service.calculate_total_profit_loss_and_gain
    @total_portfolio = portfolio_service.calculate_total_portfolio_value
    @top_stocks = Stock.get_top_stocks
    @symbol =  session[:search_symbol]

    if @symbol.present?
      @stock = Stock.new_lookup(@symbol)
    else
      @stock = nil
      flash.now[:alert] = 'Stock symbol not provided'
    end
    p @stock
    render partial: 'trader/dashboard/trader-dashboard', locals:   {
        total_profit_loss: @total_profit_loss,
        total_gain_loss: @total_gain_loss,
        total_portfolio: @total_portfolio,
        top_stocks: @top_stocks,
        stock: @stock
      }
  end

  private

  def store_transaction_data(symbol, transaction_type)
    session[:selected_stock_symbol] = symbol
    session[:transaction_type] = transaction_type
  end
end
