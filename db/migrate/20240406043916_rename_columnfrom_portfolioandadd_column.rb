class RenameColumnfromPortfolioandaddColumn < ActiveRecord::Migration[7.1]
  def change
    rename_column :portfolios, :stock, :total_value
    rename_column :portfolios, :shares, :total_profit
    add_column :portfolios, :total_loss, :decimal
  end

end
