class Stock < ApplicationRecord
  has_many :transactions, dependent: :destroy
  belongs_to :user

  validates_presence_of :symbol, :company_name, :latest_price, :shares

  def self.buy_stock(user, ticker_symbol, quantity, type)
    stock_data = new_lookup(ticker_symbol)

    return :symbol_not_found unless stock_data

    existing_stock = user.stocks.find_by(symbol: stock_data[:symbol])

    if existing_stock

      if type == 'buy'
        existing_stock.update(
          shares: existing_stock.shares + quantity,
          latest_price: stock_data[:latest_price]
        )
      elsif existing_stock.shares >= quantity
        existing_stock.update(
          shares: existing_stock.shares - quantity,
          latest_price: stock_data[:latest_price]
        )
      else
        return :insufficient_shares
      end
      existing_stock
    else

      Stock.create(
        symbol: stock_data[:symbol],
        company_name: stock_data[:company_name],
        latest_price: stock_data[:latest_price],
        shares: quantity,
        logo: stock_data[:logo],
        user_id: user.id
      )
    end
  end

  def self.new_lookup(ticker_symbol)
    stock_data = fetch_stock_data(ticker_symbol)
    p stock_data
    if stock_data
      {
        symbol: stock_data.symbol,
        company_name: stock_data.company_name,
        latest_price: stock_data.latest_price,
        change: stock_data.change,
        week_52_high: stock_data.week_52_high,
        week_52_low: stock_data.week_52_low,
        logo: fetch_logo(ticker_symbol).url
      }
    end
  end

  def self.get_top_stocks
    begin
      client = iex_client
      top_stocks = client.stock_market_list(:mostactive,listLimit: 5).map do |stock|
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

  private

  def self.fetch_stock_data(ticker_symbol)
    begin
      client = iex_client
      client.quote(ticker_symbol)
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "Symbol '#{ticker_symbol}' not found: #{e.message}"
      nil
    end
  end

  def self.fetch_logo(ticker_symbol)
    begin
      client = iex_client
      client.logo(ticker_symbol)
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "Logo for '#{ticker_symbol}' not found: #{e.message}"
      nil
    end
  end
  def self.fetch_news(ticker_symbol)
    begin
      client = iex_client
      client.news(ticker_symbol)
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "Logo for '#{ticker_symbol}' not found: #{e.message}"
      nil
    end
  end
  def self.iex_client
    IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex[:public_key],
      secret_token: Rails.application.credentials.iex[:secret_key],
      endpoint: 'https://cloud.iexapis.com/v1'
    )
  end
end
