class PortfolioService
  def initialize(user)
    @user = user
  end

  def get_pie_chart_data
    stock_values = {}
    @user.stocks.each do |stock|
    total_value = stock.latest_price * stock.shares
      if total_value > 0
        stock_values[stock.symbol] = total_value
      end
    end

    pie_chart_data = stock_values.map { |symbol, total_value| [symbol, total_value] }

    pie_chart_data
  end

  def calculate_total_portfolio_value
    @user.stocks.sum { |stock| stock.shares * stock.latest_price }
  end

  def calculate_total_profit_loss_and_gain
    total_profit_loss = 0
    total_gain_loss = 0

    @user.stocks.each do |stock|
      total_purchase = @user.transactions.where(stock_symbol: stock.symbol, transaction_type: :buy).sum(:total) || 0
      total_sales = @user.transactions.where(stock_symbol: stock.symbol, transaction_type: :sell).sum(:total) || 0

      if total_purchase != 0 && total_sales != 0
        profit_loss_total = total_sales - total_purchase
        gain_loss_total = (profit_loss_total.to_f / total_purchase.to_f) * 100
      else
        profit_loss_total = 0
        gain_loss_total = 0
      end

      total_profit_loss += profit_loss_total
      total_gain_loss += gain_loss_total
    end

    [total_profit_loss, total_gain_loss]
  end

  def get_portfolio_stocks
    porfolio_stocks = []

    @user.stocks.select(:symbol).distinct.each do |stock|
      latest_stock = @user.stocks.where(symbol: stock.symbol).order(created_at: :desc).first
      next unless latest_stock.shares.positive?

      stock_data = Stock.new_lookup(stock.symbol)
      total_purchase = @user.transactions.where(stock_symbol: stock_data[:symbol], transaction_type: :buy).sum(:total) || 0
      total_sales = @user.transactions.where(stock_symbol: stock_data[:symbol], transaction_type: :sell).sum(:total) || 0
      p total_purchase,total_sales
      profit_loss_total, gain_loss_total = calculate_profit_loss_and_gain(total_purchase, total_sales)

      p profit_loss_total,gain_loss_total
      porfolio_stocks << {
        symbol: stock.symbol,
        shares: latest_stock.shares,
        company_name: latest_stock.company_name,
        latest_price: Stock.update_latest_price(stock.symbol),
        logo: latest_stock.logo,
        profit_loss: profit_loss_total,
        gain_loss: gain_loss_total,
        created_at: latest_stock.created_at
      }
    end

    porfolio_stocks
  end

  private

  def calculate_profit_loss_and_gain(total_purchase, total_sales)
    if total_purchase != 0 && total_sales != 0
      profit_loss_total = total_sales - total_purchase
      gain_loss_total = (profit_loss_total.to_f / total_purchase.to_f) * 100
    else
      profit_loss_total = 0
      gain_loss_total = 0
    end

    [profit_loss_total, gain_loss_total]
  end
end
