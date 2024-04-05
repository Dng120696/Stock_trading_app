class Stock < ApplicationRecord
  belongs_to :portfolio

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
