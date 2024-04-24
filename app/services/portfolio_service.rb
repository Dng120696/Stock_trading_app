class PortfolioService
  def initialize(user)
    @user = user
  end

  def get_pie_chart_data
    stock_values = {}

    @user.stocks.each do |stock|
      stock_purchase = @user.transactions.where(stock_symbol: stock.symbol, transaction_type: :buy)
      stock_prices = stock_purchase.map { |transaction| transaction.stock_price }
      avg_price = calculate_avg_price(stock_prices)
      total_value = avg_price * stock.shares
      stock_values[stock.symbol] = total_value.round(3) if total_value.positive?
    end
    stock_values.map { |symbol, total_value| [symbol, total_value] }
  end

  def calculate_total_portfolio_value
    total_portfolio_value = 0
    @user.stocks.select(:symbol).distinct.each do |stock|
      latest_stock = @user.stocks.where(symbol: stock.symbol).order(created_at: :desc).first
      stock_purchase = @user.transactions.where(stock_symbol: stock.symbol, transaction_type: :buy)
      stock_prices = stock_purchase.map { |transaction| transaction.stock_price }
      avg_price = calculate_avg_price(stock_prices)
          total = avg_price * latest_stock.shares
         total_portfolio_value += total
    end
    total_portfolio_value
  end

  def calculate_total_profit_loss_and_gain
    total_profit_loss = 0
    total_gain_loss = 0

    @user.stocks.each do |stock|
      latest_stock_price = Stock.fetch_price(stock.symbol)

      stock_purchase = @user.transactions.where(stock_symbol: stock.symbol, transaction_type: :buy)
      stock_prices = stock_purchase.map { |transaction| transaction.stock_price }
      avg_price = calculate_avg_price(stock_prices)

      portfolio_stock_total = stock.shares * latest_stock_price
      total_purchase = avg_price * stock.shares

      profit_loss_total, gain_loss_total = calculate_profit_loss_and_gain(total_purchase,portfolio_stock_total)

      total_profit_loss += profit_loss_total
      total_gain_loss += gain_loss_total
    end

    [total_profit_loss, total_gain_loss]
  end

  def get_portfolio_stocks
    @user.stocks.select(:symbol).distinct.map do |stock|
      latest_stock = @user.stocks.where(symbol: stock.symbol).order(created_at: :desc).first
      latest_stock_price = Stock.fetch_price(stock.symbol)

      stock_purchase = @user.transactions.where(stock_symbol: stock.symbol, transaction_type: :buy)
      stock_prices = stock_purchase.map { |transaction| transaction.stock_price }
      avg_price = calculate_avg_price(stock_prices)

      total_purchase = avg_price * latest_stock.shares

      portfolio_stock_total = latest_stock.shares * latest_stock_price
      profit_loss_total, gain_loss_total = calculate_profit_loss_and_gain(total_purchase,portfolio_stock_total)

      {
        symbol: stock.symbol,
        shares: latest_stock.shares,
        company_name: latest_stock.company_name,
        latest_price: latest_stock_price,
        logo: latest_stock.logo,
        avg_price: avg_price,
        profit_loss: profit_loss_total,
        gain_loss: gain_loss_total,
        created_at: latest_stock.created_at
      }
    end.compact
  end

  private

  def calculate_avg_price(stock_prices)
    avg_price = stock_prices[0].to_f
    if  stock_prices.count > 1
        stock_prices.each_with_index do |stock_price,i|
          avg_price += stock_prices[i + 1].to_f
          if stock_prices.last != stock_prices[i + 1]
            avg_price /=  2
          end
         avg_price
        end
    else
         avg_price = stock_prices[0]
    end
    avg_price
  end

  def calculate_profit_loss_and_gain(total_purchase,portfolio_stock_total)
      profit_loss_total = portfolio_stock_total - total_purchase
      gain_loss_total = (profit_loss_total / total_purchase.to_f) * 100

    [profit_loss_total, gain_loss_total]
  end
end
