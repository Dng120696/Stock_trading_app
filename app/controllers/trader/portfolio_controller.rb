class Trader::PortfolioController < ApplicationController
  before_action :authenticate_user!
  before_action :portfolio_service
  def index
    @pie_chart_data = portfolio_service.get_pie_chart_data

  end

  def index_load_total
    @total_profit_loss, @total_gain_loss = portfolio_service.calculate_total_profit_loss_and_gain
    @total_portfolio = portfolio_service.calculate_total_portfolio_value
    p @total_portfolio
    render partial: 'trader/portfolio/trader-portfolio-totals', locals: {
       total_profit_loss: @total_profit_loss,
       total_gain_loss: @total_gain_loss,
       total_portfolio: @total_portfolio,
    }
  end

  def index_load_table
    @porfolio_stocks = portfolio_service.get_portfolio_stocks
    render partial: 'trader/portfolio/trader-portfolio-table',
       porfolio_stocks: @porfolio_stocks
  end

  private

  def portfolio_service
    portfolio_service = PortfolioService.new(current_user)
  end
end
