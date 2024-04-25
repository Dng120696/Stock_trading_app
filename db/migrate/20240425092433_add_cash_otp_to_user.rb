class AddCashOtpToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :cash_otp, :string
  end
end
