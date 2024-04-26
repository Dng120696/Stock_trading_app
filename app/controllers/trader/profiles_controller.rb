class Trader::ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [ :deposit_balance,:withdraw_balance,:confirm_otp,:otp_index,:deposit_index,:withdraw_index,:resend_otp]

  def index

  end
  def edit

  end

  def deposit; end
  def withdraw; end

  def confirm_otp; end

  def otp_index
    sleep(1)
    render partial: 'trader/profiles/otp-index'
  end

  def deposit_index
    sleep(1)
    render partial: 'trader/profiles/deposit-index'
  end
  def withdraw_index
    sleep(1)
    render partial: 'trader/profiles/withdraw-index'
  end

  def deposit_balance
    amount_to_deposit = params[:amount].to_f

    if invalid_amount?(amount_to_deposit)
      redirect_to_edit_with_alert('Amount must be greater than 0') and return
    end

    # Generate and store OTP
    @user.update(cash_otp: generate_otp)

    UserMailer.otp_confirmation_email(@user).deliver_now

    # Store the intended balance update for later confirmation
    session[:user_id] = @user.id
    session[:amount] = amount_to_deposit
    session[:type] = :deposit
    p session[:type],amount_to_deposit
    redirect_to confirm_otp_trader_profiles_path
  end
  def withdraw_balance
    amount_to_withdraw = params[:amount].to_f

    if invalid_amount?(amount_to_withdraw)
      redirect_to withdraw_trader_profiles_path, alert: 'Amount must be greater than 0'
      return
    elsif amount_to_withdraw > @user.balance
      redirect_to withdraw_trader_profiles_path, alert: 'Insufficient balance'
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



  def process_otp_confirmation
    @user = User.find(session[:user_id])
    amount = session[:amount]
    type = session[:type]
    otp = params[:otp]

    if @user.cash_otp == otp
      transaction = build_transaction(amount,type)

      if transaction.save

        if transaction.transaction_type == 'deposit'
        @user.update!(balance: @user.balance + amount, cash_otp: nil)
        else
          @user.update!(balance: @user.balance - amount, cash_otp: nil)
        end

        UserMailer.notify_funds_success(@user, amount,type).deliver_now

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
    @user = current_user
  end

  def invalid_amount?(amount)
    amount <= 0 || amount < 100
  end

  def build_transaction(amount,type)
    if type == 'deposit'
      @user.transactions.new(
        transaction_type: type,
        total: amount,
        user_balance: @user.balance + amount
      )
    else
      @user.transactions.new(
        transaction_type: type,
        total: amount,
        user_balance: @user.balance - amount
      )
    end
  end

  def generate_otp
    SecureRandom.hex(6 / 2).upcase
  end

  def redirect_to_edit_with_alert(alert_message)
    redirect_to edit_trader_profiles_path, alert: alert_message
  end
end
