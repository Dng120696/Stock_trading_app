class CreatePortfolios < ActiveRecord::Migration[7.1]
  def change
    create_table :portfolios do |t|
      t.string :stock
      t.integer :shares
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
