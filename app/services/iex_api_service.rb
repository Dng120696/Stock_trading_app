class IexApiService
  def initialize
    @iex_client = initialize_iex_client
  end

  def fetch_historical_prices(ticker_symbol, range)
    begin
      @iex_client.historical_prices(ticker_symbol,range)
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "Symbol '#{ticker_symbol}' not found: #{e.message}"
      nil
    end
  end

  def fetch_price(ticker_symbol)
    begin
      @iex_client.price(ticker_symbol)
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "Symbol '#{ticker_symbol}' not found: #{e.message}"
      nil
    end
  end

  def fetch_top_stocks
    begin
      @iex_client.stock_market_list(:mostactive)
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "Symbol '#{ticker_symbol}' not found: #{e.message}"
      nil
    end
  end

  def fetch_stock_quote(ticker_symbol)
    begin
      @iex_client.quote(ticker_symbol)
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "Symbol '#{ticker_symbol}' not found: #{e.message}"
      nil
    end
  end

  def fetch_logo(ticker_symbol)
    begin
      @iex_client.logo(ticker_symbol)
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "Logo for '#{ticker_symbol}' not found: #{e.message}"
      nil
    end
  end

  def fetch_news(ticker_symbol)
    begin
      @iex_client.news(ticker_symbol)
    rescue IEX::Errors::SymbolNotFoundError => e
      Rails.logger.error "News for '#{ticker_symbol}' not found: #{e.message}"
      nil
    end
  end

  private

  def initialize_iex_client
    IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex[:public_key],
      secret_token: Rails.application.credentials.iex[:secret_key],
      endpoint: 'https://cloud.iexapis.com/v1'
    )
  end
end
