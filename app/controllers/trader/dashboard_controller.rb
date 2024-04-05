class Trader::DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @top_stocks = Stock.get_top_stocks
    if params[:search].present?
      begin
        @stock = Stock.new_lookup(params[:search])
      rescue IEX::Errors::SymbolNotFoundError
        @stock = nil
      end
    end
    render 'trader/dashboard/index'
  end
end
