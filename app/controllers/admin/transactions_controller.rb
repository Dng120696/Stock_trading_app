class Trader::TransactionsController < ApplicationController
    def index
    @transactions = Transaction.all
  end
