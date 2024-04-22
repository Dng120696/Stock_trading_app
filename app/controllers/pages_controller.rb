class PagesController < ApplicationController
  def home
    if user_signed_in? || admin_user_signed_in?
      flash[:alert] = "You are already signed in."
      redirect_to news_path
    end
  end

  def news
    @stock_news = Stock.fetch_news('MSFT')
  end
end
