class PortfolioService
  def initialize(user)
    @user = user
  end

  def get_pie_chart_data
    stock_values = {}

    @user.stocks.each do |stock|
      avg_price = get_avg_price(@user,stock)
      total_value = avg_price * stock.shares
      stock_values[stock.symbol] = total_value.round(3) if total_value != 0
    end

    stock_values
  end

  def calculate_total_portfolio_value
    total_portfolio_value = 0

    @user.stocks.distinct(:symbol).each do |stock|
      avg_price = get_avg_price(@user,stock)
      total = avg_price * stock.shares
      total_portfolio_value += total
    end

    total_portfolio_value
  end

  def calculate_total_profit_loss_and_gain
    total_profit_loss = 0
    total_gain_loss = 0

    @user.stocks.each do |stock|
      latest_stock_price = Stock.fetch_price(stock.symbol)
      avg_price = get_avg_price(@user,stock)
      portfolio_stock_total = stock.shares * latest_stock_price
      total_purchase = avg_price * stock.shares
      profit_loss_total, gain_loss_total = calculate_profit_loss_and_gain(total_purchase,portfolio_stock_total)

      total_profit_loss += profit_loss_total
      total_gain_loss += gain_loss_total
    end

    [total_profit_loss, total_gain_loss]
  end

  def get_portfolio_stocks
    @user.stocks.distinct(:symbol).map do |stock|
      latest_stock_price = Stock.fetch_price(stock.symbol)
      avg_price = get_avg_price(@user,stock)
      total_purchase = avg_price * stock.shares
      portfolio_stock_total = (stock.shares * latest_stock_price).round(2)
      profit_loss_total, gain_loss_total = calculate_profit_loss_and_gain(total_purchase,portfolio_stock_total)

      {
        symbol: stock.symbol,
        shares: stock.shares,
        company_name: stock.company_name,
        latest_price: latest_stock_price,
        logo: stock.logo,
        avg_price: avg_price,
        profit_loss: profit_loss_total,
        gain_loss: gain_loss_total,
        created_at: stock.created_at
      }
    end
  end

  private
  def get_avg_price(user,stock)
    stock_prices = get_stock_prices(@user,stock)
    calculate_avg_price(stock_prices).round(2)
  end

  def get_stock_prices(user,stock)
    stock_purchase = user.transactions.where(stock_symbol: stock.symbol, transaction_type: :buy)
    stock_purchase.pluck(:stock_price)
  end

  def calculate_avg_price(stock_prices)
    return stock_prices.first if stock_prices.one?

    sum = stock_prices.sum(&:to_f)
    sum / stock_prices.size
  end

  def calculate_profit_loss_and_gain(total_purchase, portfolio_stock_total)
    return [0, 0] if total_purchase.zero?

    profit_loss_total = portfolio_stock_total - total_purchase
    gain_loss_total = (profit_loss_total.to_f / total_purchase) * 100
    [profit_loss_total, gain_loss_total]
  end
end
