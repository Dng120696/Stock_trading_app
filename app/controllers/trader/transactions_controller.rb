class Trader::TransactionsController < ApplicationController
  before_action :authenticate_user!
  def index
      @transactions = current_user.transactions
  end
  def new
    @stock = Stock.new_lookup(params[:transaction][:stock_symbol])
    @historical_data = fetch_historical_prices(params[:transaction][:stock_symbol])
    p @historical_data
    @transaction = current_user.transactions.new(transaction_params)

  end
  def create
    @transaction = current_user.transactions.new(transaction_params)
    @transaction.total = @transaction.quantity * @transaction.stock_price

    unless transaction_valid?
      redirect_with_flash('Not enough money') and return
    end

    @stock = Stock.buy_stock(current_user, @transaction.stock_symbol, @transaction.quantity, @transaction.transaction_type)

    case @stock
    when :insufficient_shares
      redirect_with_flash('Not enough Shares.') and return
    when :symbol_not_found
      redirect_with_flash('Error buying stock. Stock symbol not found.') and return
    end

    # Continue with processing the transaction
    @transaction.stock_id = @stock.id

    if @transaction.save
      update_user_balance
      redirect_to trader_transactions_path, notice: 'Transaction Complete'
    else
      redirect_to new_trader_transaction_path(transaction: transaction_params), notice: 'Transaction Failed'
    end
  end

  private

  def transaction_valid?
    current_user.balance >= @transaction.total
  end

  def redirect_with_flash(message)
    flash[:notice] = message
    redirect_to new_trader_transaction_path(transaction: transaction_params)
  end

  def update_user_balance
    if @transaction.buy?
      current_user.update(balance: current_user.balance - @transaction.total_cost)
    elsif @transaction.sell?
      current_user.update(balance: current_user.balance + @transaction.total_cost)
    end
  end

  def fetch_historical_prices(symbol)
    client = Stock.iex_client

    # Fetch historical prices for the last 3 months
    historical_prices = client.historical_prices(symbol, range: '1m')

    # Fetch the latest price for today
    latest_price_entry = client.quote(symbol)

    # Extract the latest price and date
    latest_price = latest_price_entry.latest_price
    today = Date.today

    # Append the latest price to the historical data
    historical_data = historical_prices.map { |entry| [entry.date, entry.close] }
    historical_data << [today, latest_price]

    return historical_data
  end


  def transaction_params
    params.require(:transaction).permit(:stock_symbol, :quantity, :stock_price, :transaction_type,:total)
  end
end
