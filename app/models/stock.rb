class Stock < ApplicationRecord
  has_many :transactions
  belongs_to :user
  def self.buy_stock(user, ticker_symbol, quantity)
    # Fetch stock data from API
    stock_data = new_lookup(ticker_symbol)

    if stock_data.present?
      existing_stock = user.stocks.find_by(symbol: stock_data.symbol)
      if existing_stock
        # Update quantity and total price if the stock already exists
        existing_stock.update(
          shares: existing_stock.shares + quantity,
          latest_price: stock_data.latest_price
        )
        existing_stock
      else
        # Create a new stock if it doesn't exist
        Stock.create(
          symbol: stock_data.symbol,
          company_name: stock_data.company_name,
          latest_price: stock_data.latest_price,
          shares: quantity,
          user_id: user.id
        )
      end
    else
      nil  # Return nil if the symbol is not found or there's an error
    end
  end



  def self.new_lookup(ticker_symbol)
    begin
      client = IEX::Api::Client.new(
        publishable_token: Rails.application.credentials.iex[:public_key],
        secret_token: Rails.application.credentials.iex[:secret_key],
        endpoint: 'https://cloud.iexapis.com/v1'
      )

    client.quote(ticker_symbol)
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "Symbol '#{ticker_symbol}' not found: #{e.message}"
      nil  # Return nil if the symbol is not found
    end
  end
  def self.get_top_stocks
    begin
      client = IEX::Api::Client.new(
        publishable_token: Rails.application.credentials.iex[:public_key],
        secret_token: Rails.application.credentials.iex[:secret_key],
        endpoint: 'https://cloud.iexapis.com/v1'
      )

    client.stock_market_list(:mostactive)
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "Symbol '#{ticker_symbol}' not found: #{e.message}"
      nil  # Return nil if the symbol is not found
    end
  end

end
