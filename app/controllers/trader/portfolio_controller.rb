class Trader::PortfolioController < ApplicationController
  before_action :authenticate_user!
  def index
    portfolio_service = PortfolioService.new(current_user)
    @porfolio_stocks = portfolio_service.get_portfolio_stocks
    @total_portfolio = portfolio_service.calculate_total_portfolio_value
    @total_profit_loss, @total_gain_loss = portfolio_service.calculate_total_profit_loss_and_gain
    @pie_chart_data = portfolio_service.get_pie_chart_data
  end
end
