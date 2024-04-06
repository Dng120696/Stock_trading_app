class ChangeColumnTypefromPortfolio < ActiveRecord::Migration[7.1]
  def change
    change_column :portfolios, :total_value, :decimal, using: 'total_value::decimal'
    change_column :portfolios, :total_profit, :decimal, using: 'total_profit::decimal'
  end
end
