class DropTablePortfolio < ActiveRecord::Migration[7.1]
  def change
    remove_column :stocks, :portfolio_id
    drop_table :portfolios
  end
end
