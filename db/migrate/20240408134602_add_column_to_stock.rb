class AddColumnToStock < ActiveRecord::Migration[7.1]
  def change
    add_column :stocks, :logo, :string
  end
end
