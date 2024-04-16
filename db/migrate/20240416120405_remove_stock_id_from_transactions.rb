class RemoveStockIdFromTransactions < ActiveRecord::Migration[7.1]
  def change
    remove_column :transactions, :stock_id
  end
end
