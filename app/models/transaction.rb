class Transaction < ApplicationRecord
  belongs_to :user

  enum transaction_type: { buy: 0, sell: 1 }

  validates_presence_of :quantity, :transaction_type, :stock_price, :stock_symbol,:total


  def self.create_and_update_stock(user,transaction_attr)
    ActiveRecord::Base.transaction do
      @transaction = user.transactions.new(transaction_attr)
      @transaction.total =(transaction_attr[:quantity].to_i * transaction_attr[:stock_price].to_f).round(2)
      @transaction.save!

      if user.balance < @transaction.total
        raise ActiveRecord::RecordInvalid.new(@transaction), "Insufficient balance"
      end

      stock_data = Stock.new_lookup(transaction_attr[:stock_symbol])
      existing_stock = user.stocks.find_by(symbol: stock_data[:symbol])


      if existing_stock
        if transaction_attr[:transaction_type] == 'buy'
          if existing_stock.shares == 0 || existing_stock.shares > transaction_attr[:quantity].to_i
            existing_stock.update!(
              shares: existing_stock.shares + transaction_attr[:quantity].to_i,
              latest_price: stock_data[:latest_price]

            )
            user.balance -= @transaction.total
            user.save!
          end
        else
          if existing_stock.shares < transaction_attr[:quantity].to_i
            raise ActiveRecord::RecordInvalid.new(@transaction), "Insufficient shares of stock"
          else
            existing_stock.update!(
              shares: existing_stock.shares - transaction_attr[:quantity].to_i,
              latest_price: stock_data[:latest_price]

            )
          user.balance += @transaction.total
           user.save!
          end
        end
      else
        user.balance -= @transaction.total
        user.save!
        stock = user.stocks.new(
                symbol: stock_data[:symbol],
                company_name: stock_data[:company_name],
                latest_price: stock_data[:latest_price],
                shares: transaction_attr[:quantity],
                logo: stock_data[:logo]
                )
        stock.save!
      end
    end
  end
end
