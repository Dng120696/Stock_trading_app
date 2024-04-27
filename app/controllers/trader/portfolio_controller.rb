class Trader::PortfolioController < ApplicationController
  include PortfolioCommon
  def index
    @pie_chart_data = portfolio_service.get_pie_chart_data
  end

  def index_load_total
    #method in concern files(portfolio_common)
    calculate_portfolio_totals

    render partial: 'trader/portfolio/trader-portfolio-totals'
  end

  def index_load_table
    @porfolio_stocks = portfolio_service.get_portfolio_stocks
    p @porfolio_stocks
    render partial: 'trader/portfolio/trader-portfolio-table'
  end

end
