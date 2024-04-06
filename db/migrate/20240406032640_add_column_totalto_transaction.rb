class AddColumnTotaltoTransaction < ActiveRecord::Migration[7.1]
  def change
    add_column :transactions, :total, :decimal
  end
end
