class Trader::TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def index_load
    sleep(1)
    @transactions = current_user.transactions.order(created_at: :desc)
    render partial: 'trader/transactions/transaction-index', transactions: @transactions
  end

  def new
    @stock_symbol = params[:transaction][:stock_symbol]
    @stock = Stock.fetch_stock_details(@stock_symbol)
    @chart_data = Stock.fetch_historical_prices(@stock_symbol)
    @transaction = current_user.transactions.new(transaction_params)
    p @transaction
  end

  def create
    Transaction.create_and_update_stock(current_user, transaction_params)
    redirect_to trader_transactions_path, notice: 'Transaction Complete'
    rescue ActiveRecord::RecordInvalid => e
    redirect_to new_trader_transaction_path(transaction: transaction_params), alert: e.message
  end

  private

  def transaction_params
    params.require(:transaction).permit(:stock_symbol, :quantity, :stock_price, :transaction_type,:total)
  end
end
