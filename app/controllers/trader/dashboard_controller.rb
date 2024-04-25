class Trader::DashboardController < ApplicationController
  include PortfolioCommon
  def index
  end

  def search_symbol
    session[:search_symbol] = params[:search]
    redirect_to trader_dashboard_index_path
  end

  def index_load
    #method in concern files(portfolio_common)
    calculate_portfolio_totals
    @top_stocks = Stock.get_top_stocks
    @symbol =  session[:search_symbol]

    if @symbol.present?
      @stock = Stock.new_lookup(@symbol)
    else
      @stock = nil
      flash.now[:alert] = 'Stock symbol not provided'
    end
    render partial: 'trader/dashboard/trader-dashboard'
  end

  private

  def store_transaction_data(symbol, transaction_type)
    session[:selected_stock_symbol] = symbol
    session[:transaction_type] = transaction_type
  end
end
