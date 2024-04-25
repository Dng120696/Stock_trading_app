module PortfolioCommon
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :portfolio_service
  end

  private

  def portfolio_service
    @portfolio_service ||= PortfolioService.new(current_user)
  end

  def calculate_portfolio_totals
    @total_profit_loss, @total_gain_loss = portfolio_service.calculate_total_profit_loss_and_gain
    @total_portfolio = portfolio_service.calculate_total_portfolio_value
  end
end
