class AddLogoToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_column :transactions, :logo, :string
  end
end
