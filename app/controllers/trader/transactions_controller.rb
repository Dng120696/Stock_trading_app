class Trader::TransactionsController < ApplicationController

  def index
      @transactions = current_user.transactions
  end
  def new
    @transaction = current_user.transactions.new(transaction_params)

  end
  def create
    @transaction = current_user.transactions.new(transaction_params)
    @transaction.total = @transaction.quantity * @transaction.stock_price

    unless transaction_valid?
      redirect_with_flash('Not enough money') and return
    end

    @stock = Stock.buy_stock(current_user, @transaction.stock_symbol, @transaction.quantity, @transaction.transaction_type)
    puts @stock
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
      redirect_to trader_dashboard_index_path, notice: 'Transaction Complete'
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
  def transaction_params
    params.require(:transaction).permit(:stock_symbol, :quantity, :stock_price, :transaction_type,:total)
  end
end
