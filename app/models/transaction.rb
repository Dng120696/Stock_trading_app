class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  enum transaction_type: { buy: 0, sell: 1 }
  after_create :destroy_stock_shares_0

  validates_presence_of :quantity, :transaction_type, :stock_price, :stock_symbol,:total

  def destroy_stock_shares_0
      stock.destroy if stock.shares <= 0
  end
  def total_cost
    quantity * stock_price
  end


end
