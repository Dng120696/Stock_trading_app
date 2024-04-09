class Trader::PortfolioController < ApplicationController
  before_action :authenticate_user!
  def index
    @stocks = current_user.stocks.select(:symbol).distinct.map do |stock|
      current_user.stocks.where(symbol: stock.symbol).last
    end
    puts @stocks
  end
end
