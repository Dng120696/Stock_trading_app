class AdminUsers::SessionsController < Devise::SessionsController
  def create
    if user_signed_in?
      sign_out(current_user) # Sign out user
    end
    super
  end
end
