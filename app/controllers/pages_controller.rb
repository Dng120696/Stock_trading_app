class PagesController < ApplicationController

  def home
    @stock_news = Stock.fetch_news('MSFT')
    p @stock_news
  end
end
