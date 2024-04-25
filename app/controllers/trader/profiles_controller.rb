class Trader::ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [ :add_balance,:confirm_otp,:otp_index,:deposit_balance,:resend_otp]

  def edit; end

  def confirm_otp; end

  def otp_index
    sleep(1)
    render partial: 'trader/profiles/otp-index'
  end

  def deposit_balance
    sleep(1)
    render partial: 'trader/profiles/deposit-balance'
  end

  def add_balance
    amount_to_add = params[:amount].to_f

    if invalid_amount?(amount_to_add)
      redirect_to_edit_with_alert('Amount must be greater than 0') and return
    end

    # Generate and store OTP
    @user.update(cash_otp: generate_otp)

    UserMailer.otp_confirmation_email(@user).deliver_now

    # Store the intended balance update for later confirmation
    session[:user_id] = @user.id
    session[:amount] = amount_to_add

    redirect_to confirm_otp_trader_profiles_path
  end



  def process_otp_confirmation
    @user = User.find(session[:user_id])
    amount_to_add = session[:amount]

    otp = params[:otp]

    if @user.cash_otp == otp
      transaction = build_transaction(amount_to_add)

      if transaction.save
        @user.update!(balance: @user.balance + amount_to_add, cash_otp: nil)

        UserMailer.notify_funds_added_success(@user, amount_to_add).deliver_now

        session.delete(:user_id)
        session.delete(:amount)

        redirect_to trader_transactions_path, notice: 'Updating balance was successful'
      else
        redirect_to_edit_with_alert('Updating balance was unsuccessful')
      end
    else
      redirect_to confirm_otp_trader_profiles_path, alert: 'Invalid OTP'
    end
  end

  def resend_otp
    @user.update(cash_otp: generate_otp)
    UserMailer.otp_confirmation_email(@user).deliver_now
    redirect_to confirm_otp_trader_profiles_path, notice: 'OTP has been resent.'
  end

  private

  def set_user
    @user = current_user # Assuming you have Devise or similar for authentication
  end

  def invalid_amount?(amount)
    amount <= 0 || amount < 100
  end

  def build_transaction(amount)
    @user.transactions.new(
      transaction_type: :deposit,
      total: amount,
      user_balance: @user.balance + amount
    )
  end

  def generate_otp
    SecureRandom.hex(6 / 2).upcase # Generate a random OTP
  end

  def redirect_to_edit_with_alert(alert_message)
    redirect_to edit_trader_profiles_path, alert: alert_message
  end
end
