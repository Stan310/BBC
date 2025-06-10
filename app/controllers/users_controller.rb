class UsersController < ApplicationController
  def account
    @balance_history = current_user.balance_histories.order(:created_at)
  end
end
