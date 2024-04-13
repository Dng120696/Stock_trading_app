class AddColumnLastAvgPriceToStock < ActiveRecord::Migration[7.1]
  def change
    add_column :stocks, :last_avg_price, :decimal
  end
end
