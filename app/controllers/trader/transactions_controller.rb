class Trader::TransactionsController < ApplicationController

  def new
    @transaction = current_user.transactions.new(transaction_params)

  end
  def create
    @transaction = current_user.transactions.new(transaction_params)
    @stock = Stock.buy_stock(current_user, @transaction.stock_symbol, @transaction.quantity)
    puts "@stock: #{@stock.inspect}"
    if @stock.nil?
      flash[:error] = "Error buying stock. Stock symbol not found."
      redirect_to new_trader_transaction_path(transaction_params)
      return
    end

    @transaction.total = @transaction.quantity * @transaction.stock_price
    @transaction.stock_id = @stock.id

    if @transaction.save
      update_user_balance
      redirect_to trader_dashboard_index_path, notice: 'Transaction Complete'
    else
      redirect_to new_trader_transaction_path(transaction: transaction_params), notice: 'Transaction Failed'
    end
  end


  private
  def update_user_balance
    if @transaction.buy?
      current_user.update(balance: current_user.balance - @transaction.total_cost)
    elsif @transaction.sell?
      current_user.update(balance: current_user.balance + @transaction.total_cost)
    end
  end
  def transaction_params
    params.require(:transaction).permit(:stock_symbol, :quantity, :stock_price, :transaction_type,:total)
  end
end
