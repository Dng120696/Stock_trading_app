class Trader::DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_portfolio = 0
    current_user.stocks.each do |stock|
      total_stock = stock.shares * stock.latest_price
      @total_portfolio += total_stock
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
