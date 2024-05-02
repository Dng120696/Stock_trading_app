class Trader::ProfilesController < ApplicationController
  include PortfolioCommon
  before_action :set_user, only: [:index, :edit,:edit_password,:update, :change_password, :confirm_otp, :otp_index, :resend_otp,:upload_image]

  def index
     @total_deposit = @user.transactions.where(transaction_type: :deposit).sum(:total)
     @total_withdraw = @user.transactions.where(transaction_type: :withdraw).sum(:total)
     @capital_gain_loss = (@user.balance + portfolio_service.calculate_total_portfolio_value) -(@total_deposit - @total_withdraw)

    end

   def edit; end

  def edit_password; end

  def update
    if @user.update(params.require(:user).permit(:firstname, :lastname, :email))
      if @user.previous_changes.present?
        flash[:notice] = 'Profile updated successfully'
     else
       flash[:alert] = 'No Changes were made.'
     end
        redirect_to profile_trader_profiles_path
    else
      redirect_to :edit, alert: 'Profile not updated'
    end
  end

  def upload_image
    profile_picture = params[:profile_picture]

    if @user.update(profile_picture: profile_picture)
      redirect_to profile_trader_profiles_path
    end

  end

  def change_password
      old_password = params[:old_password]
      new_password = params[:new_password]
      password_confirmation = params[:password_confirmation]

      if @user.valid_password?(old_password) && new_password == password_confirmation
          @user.update!(password: new_password)
          redirect_to profile_trader_profiles_path ,alert: 'Account Password Updated Successfully '
      else
        redirect_to edit_password_trader_profiles_path ,alert: 'Password Incorrect'
      end

  end

  def confirm_otp; end

  def otp_index
    sleep(1)
    render partial: 'trader/profiles/otp-index'
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
        session.delete(:type)

        redirect_to trader_transactions_path, notice: 'Updating balance was successful'
      else
        redirect_to confirm_otp_trader_profiles_path, alert: 'Transaction Faileds'
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

  def build_transaction(amount,type)
      @user.transactions.new(
        transaction_type: type,
        total: amount,
        user_balance: type == 'deposit' ? @user.balance + amount : @user.balance - amount
      )

  end



end
