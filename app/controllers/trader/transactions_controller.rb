class Trader::TransactionsController < ApplicationController
  before_action :authenticate_user!
  def index
    @transactions = current_user.transactions.order(created_at: :desc)

    @transactions = @transactions.map do |transaction|
      {
        stock_symbol: transaction.stock_symbol,
        quantity: transaction.quantity,
        type: transaction.transaction_type,
        stock_price: transaction.stock_price,
        total: transaction.total,
        created_at: transaction.created_at,
        logo: Stock.fetch_logo(transaction.stock_symbol).url
      }
    end
  end

  def new
    @stock = Stock.fetch_stock_details(params[:transaction][:stock_symbol])
    @historical_data = fetch_historical_prices(params[:transaction][:stock_symbol])

    @transaction = current_user.transactions.new(transaction_params)
  end

  def create
      Transaction.create_and_update_stock(current_user, transaction_params)
        redirect_to trader_transactions_path, notice: 'Transaction Complete'
      rescue ActiveRecord::RecordInvalid => e
        redirect_to new_trader_transaction_path(transaction: transaction_params), alert: e.message
  end


  private

  def fetch_historical_prices(symbol)
    client = Stock.iex_client
    historical_prices = client.historical_prices(symbol, range: '1m')
    latest_price_entry = client.quote(symbol)
    latest_price = latest_price_entry.latest_price
    today = Date.today

    historical_data = historical_prices.map { |entry| [entry.date, entry.close] }
    historical_data << [today, latest_price]
    historical_data
  end


  def transaction_params
    params.require(:transaction).permit(:stock_symbol, :quantity, :stock_price, :transaction_type,:total)
  end
end
