class PagesController < ApplicationController

  def home
    @stock_news = Stock.fetch_news('MSFT')
  end

end
