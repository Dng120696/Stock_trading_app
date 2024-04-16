# app/models/stock.rb
class Stock < ApplicationRecord
  belongs_to :user

  validates_presence_of :symbol, :company_name, :latest_price, :shares,:logo
  validates :shares, numericality: { greater_than_or_equal_to: 0 }

  def self.update_latest_price(ticker_symbol)
    begin
      iex_api_service.fetch_price(ticker_symbol)
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "Symbol not found: #{e.message}"
      nil
    end
  end

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
    historical_price = iex_api_service.fetch_historical_prices(ticker_symbol, { range: '5d' })
    if stock_data
      {
        logo: iex_api_service.fetch_logo(ticker_symbol).url,
        symbol: stock_data.symbol,
        company_name: stock_data.company_name,
        latest_price: stock_data.latest_price,
        change_percent: stock_data.change_percent,
        week_52_high: stock_data.week_52_high,
        high: historical_price.first.high,
        low: historical_price.first.low,
        market_cap: stock_data.market_cap,
        latest_volume: historical_price.first.volume,
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

  def self.fetch_historical_prices(ticker_symbol)
    begin
      historical_prices = iex_api_service.fetch_historical_prices(ticker_symbol, range: '1m')
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
