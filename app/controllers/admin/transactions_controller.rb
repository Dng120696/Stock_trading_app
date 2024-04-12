class Admin::TransactionsController < ApplicationController
  before_action :authenticate_admin_user!

    def index
    @transactions = Transaction.all
    end
  end
