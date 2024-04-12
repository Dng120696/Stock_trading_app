class Trader::PortfolioController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_portfolio = 0
    current_user.stocks.each do |stock|
      total_stock = stock.shares * stock.latest_price
      @total_portfolio += total_stock
  end

    stock_values = {}
    current_user.stocks.each do |stock|
    total_value = stock.latest_price * stock.shares
    if total_value > 0
      stock_values[stock.symbol] = total_value
    end
    end

    @pie_chart_data = stock_values.map { |symbol, total_value| [symbol, total_value] }

    @stocks = current_user.stocks.select(:symbol).distinct.map do |stock|
      latest_stock = current_user.stocks.where(symbol: stock.symbol).order(created_at: :desc).first
      latest_stock if latest_stock.shares > 0
    end.compact

  end
end
