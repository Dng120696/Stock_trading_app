# app/models/stock.rb
class Stock < ApplicationRecord
  belongs_to :user

  validates_presence_of :symbol, :company_name, :latest_price, :shares,:logo
  validates :shares, numericality: { greater_than_or_equal_to: 0 }

  def self.new_lookup(ticker_symbol)
    stock_data = iex_api_service.fetch_stock_quote(ticker_symbol)
    if stock_data
      {
        logo: iex_api_service.fetch_logo(ticker_symbol).url,
        symbol: stock_data.symbol,
        company_name: stock_data.company_name,
        latest_price: stock_data.latest_price,
        change: stock_data.change,
        week_52_high: stock_data.week_52_high,
        week_52_low: stock_data.week_52_low
      }
    end
  end

  def self.fetch_stock_details(ticker_symbol)
    stock_data = iex_api_service.fetch_stock_quote(ticker_symbol)
    historical_price_data = iex_api_service.fetch_historical_prices(ticker_symbol)

    highest_price = nil
    lowest_price = nil

    historical_price_data.each do |price_data|
      # Check if the price data is not nil (skip entries with nil prices)
      next if price_data.high.nil? || price_data.high.nil?

      highest_price = price_data.high if highest_price.nil? || price_data.high > highest_price
      lowest_price = price_data.low if lowest_price.nil? || price_data.low < lowest_price
    end

    if stock_data
      {
        logo: iex_api_service.fetch_logo(ticker_symbol).url,
        symbol: stock_data.symbol,
        company_name: stock_data.company_name,
        latest_price: stock_data.latest_price,
        change_percent: stock_data.change_percent,
        week_52_high: stock_data.week_52_high,
        high: highest_price,
        low: lowest_price,
        market_cap: stock_data.market_cap,
        latest_volume: historical_price_data[historical_price_data.length - 2].volume,
      }
    end
  end

  def self.get_top_stocks
    begin
      top_stocks = iex_api_service.fetch_top_stocks.map do |stock|
        {
          symbol: stock.symbol,
          company_name: stock.company_name,
          latest_price: stock.latest_price,
          change: stock.change,
          week_52_high: stock.week_52_high,
          week_52_low: stock.week_52_low,
          logo: iex_api_service.fetch_logo(stock.symbol).url
        }
      end
      top_stocks
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "Top 10 Stocks not found: #{e.message}"
      nil
    end
  end

  def self.fetch_chart_data(ticker_symbol)
    begin
      historical_prices = iex_api_service.fetch_historical_prices(ticker_symbol)
      latest_price_entry = iex_api_service.fetch_stock_quote(ticker_symbol)
      latest_price = latest_price_entry.latest_price
      today = Date.today

      historical_data = historical_prices.map { |entry| [entry.date, entry.close] }
      historical_data << [today, latest_price]
      historical_data
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "Historical Price not found: #{e.message}"
      nil
    end
  end

  def self.fetch_logo(ticker_symbol)
        iex_api_service.fetch_logo(ticker_symbol)
  end
  def self.fetch_news(ticker_symbol)
        iex_api_service.fetch_news(ticker_symbol)
  end
  def self.fetch_price(ticker_symbol)
        iex_api_service.fetch_price(ticker_symbol)
  end

  private

  def self.iex_api_service
    @iex_api_service ||= IexApiService.new
  end
end
