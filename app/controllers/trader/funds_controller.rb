class Trader::FundsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [ :deposit_balance, :withdraw_balance, :deposit_index, :withdraw_index]

  def deposit; end
  def withdraw; end


  def deposit_index
    sleep(1)
    render partial: 'trader/funds/deposit-index'
  end
  def withdraw_index
    sleep(1)
    render partial: 'trader/funds/withdraw-index'
  end

  def deposit_balance
    amount_to_deposit = params[:amount].to_f

    if invalid_amount?(amount_to_deposit)
      redirect_to deposit_trader_funds_path, alert: 'Amount must be greater than 0'
      return
    end
    if amount_to_deposit > 1000000
      redirect_to deposit_trader_funds_path, alert: 'Deposit Exceeds $1,000,000.00'
      return
    end

    # Generate and store OTP
    @user.update(cash_otp: generate_otp)

    UserMailer.otp_confirmation_email(@user).deliver_now

    # Store the intended balance update for later confirmation
    session[:user_id] = @user.id
    session[:amount] = amount_to_deposit
    session[:type] = :deposit

    redirect_to confirm_otp_trader_profiles_path
  end

  def withdraw_balance
    amount_to_withdraw = params[:amount].to_f

    if invalid_amount?(amount_to_withdraw)
      redirect_to withdraw_trader_funds_path, alert: 'Amount must be greater than 0'
      return
    elsif amount_to_withdraw > @user.balance
      redirect_to withdraw_trader_funds_path, alert: 'Insufficient balance'
      return
    end

    # Generate and store OTP
    @user.update(cash_otp: generate_otp)

    UserMailer.otp_confirmation_email(@user).deliver_now

    # Store the intended balance update for later confirmation
    session[:user_id] = @user.id
    session[:amount] = amount_to_withdraw
    session[:type] = :withdraw

    redirect_to confirm_otp_trader_profiles_path
  end


  private

  def set_user
    @user = current_user
  end

  def generate_otp
    SecureRandom.hex(6 / 2).upcase
  end

  def invalid_amount?(amount)
    amount <= 0 || amount < 100
  end
end
