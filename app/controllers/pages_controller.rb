class PagesController < ApplicationController
  before_action :authenticate_user!,only: [:news]

  def home
    if user_signed_in?
      flash[:alert] = "You are already signed in."
      redirect_to news_path
    elsif admin_user_signed_in?
      flash[:alert] = "You are already signed in."
      redirect_to admin_dashboard_index_path
    end
  end

  def news
  end

  def news_load
    sleep(1)
    @news = Stock.fetch_news('MSFT')

    render partial: 'pages/stock-news'
  end

end
