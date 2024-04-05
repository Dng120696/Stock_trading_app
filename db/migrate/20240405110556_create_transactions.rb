class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.integer :transaction_type, default: 0
      t.string :stock_symbol
      t.integer :quantity
      t.decimal :stock_price
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
