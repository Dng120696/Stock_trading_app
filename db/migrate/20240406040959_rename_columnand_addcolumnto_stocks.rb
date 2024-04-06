class RenameColumnandAddcolumntoStocks < ActiveRecord::Migration[7.1]
  def change
      add_column :stocks, :shares, :integer
      rename_column :stocks, :ticker, :symbol
  end
end
