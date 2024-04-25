class Transaction < ApplicationRecord
  belongs_to :user

  enum transaction_type: { buy: 0, sell: 1, deposit: 2 }




  def self.create_and_update_stock(user,transaction_attr)
    ActiveRecord::Base.transaction do
      transaction = user.transactions.new(transaction_attr)
      logo_url = Stock.fetch_logo(transaction_attr[:stock_symbol]).url
      transaction.logo = logo_url
      transaction.total =(transaction_attr[:quantity].to_i * transaction_attr[:stock_price].to_f).round(2)
      if transaction[:transaction_type] == 'buy'
        transaction.user_balance = user.balance -  transaction.total
      else
        transaction.user_balance = user.balance +  transaction.total
      end
      transaction.save!

      if user.balance < transaction.total
        raise ActiveRecord::RecordInvalid.new(transaction), "Insufficient balance"
      end

      stock_data = Stock.new_lookup(transaction_attr[:stock_symbol])
      existing_stock = user.stocks.find_by(symbol: stock_data[:symbol])


      if existing_stock

        if transaction_attr[:transaction_type] == 'buy'
          if existing_stock.shares == 0
            existing_stock.update!(
              shares: existing_stock.shares + transaction_attr[:quantity].to_i,
              latest_price: stock_data[:latest_price],
            )
            user.balance -= transaction.total
            user.save!
            return
          end
          existing_stock.update!(
            shares: existing_stock.shares + transaction_attr[:quantity].to_i,
            latest_price: stock_data[:latest_price],
          )
          user.balance -= transaction.total
          user.save!
        else
          if existing_stock.shares < transaction_attr[:quantity].to_i
            raise ActiveRecord::RecordInvalid.new(transaction), "Insufficient shares of stock"
          else
            existing_stock.update!(
              shares: existing_stock.shares - transaction_attr[:quantity].to_i,
              latest_price: stock_data[:latest_price]

            )
          user.balance += transaction.total
           user.save!
          end
        end
      else
        user.balance -= transaction.total
        user.save!

        stock = user.stocks.new(
                symbol: stock_data[:symbol],
                company_name: stock_data[:company_name],
                latest_price: stock_data[:latest_price],
                shares: transaction_attr[:quantity],
                logo: stock_data[:logo],
                )
        stock.save!
      end
    end
  end
end
