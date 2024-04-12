class AddReferencesToStocksAndTransactions < ActiveRecord::Migration[7.1]
  def change
    add_reference :stocks, :user, null: false, foreign_key: true
  end
end
