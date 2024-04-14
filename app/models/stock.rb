class Stock < ApplicationRecord
  belongs_to :user

  validates_presence_of :symbol, :company_name, :latest_price, :shares
  validates :shares, numericality: { greater_than_or_equal_to: 0 }


  def self.update_latest_price(ticker_symbol)
    begin
      client = iex_client
      client.price(ticker_symbol)
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "Symbol not found: #{e.message}"
      nil
    end
  end

  def self.new_lookup(ticker_symbol)
      stock_data = fetch_stock_quote(ticker_symbol)
      if stock_data
        {
          logo: fetch_logo(ticker_symbol).url,
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
      stock_data = fetch_stock_quote(ticker_symbol)
      historical_price = iex_client.historical_prices(ticker_symbol, { range: '5d' })
      if stock_data
        {
          logo: fetch_logo(ticker_symbol).url,
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
        client = iex_client
        top_stocks = client.stock_market_list(:mostactive).map do |stock|
          {
            symbol: stock.symbol,
            company_name: stock.company_name,
            latest_price: stock.latest_price,
            change: stock.change,
            week_52_high: stock.week_52_high,
            week_52_low: stock.week_52_low,
            logo: fetch_logo(stock.symbol).url
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
      client = iex_client
      historical_prices = client.historical_prices(ticker_symbol, range: '1m')
      latest_price_entry = client.quote(ticker_symbol)
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

  def self.fetch_stock_quote(ticker_symbol)
    begin
      iex_client.quote(ticker_symbol)
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "Symbol '#{ticker_symbol}' not found: #{e.message}"
      nil
    end
  end

  def self.fetch_logo(ticker_symbol)
    begin
      iex_client.logo(ticker_symbol)
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "Logo for '#{ticker_symbol}' not found: #{e.message}"
      nil
    end
  end

  def self.fetch_news(ticker_symbol)
    begin
      iex_client.news(ticker_symbol)
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "News for '#{ticker_symbol}' not found: #{e.message}"
      nil
    end
  end

  def self.iex_client
    @iex_client ||= IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex[:public_key],
      secret_token: Rails.application.credentials.iex[:secret_key],
      endpoint: 'https://cloud.iexapis.com/v1'
    )
  end
end
