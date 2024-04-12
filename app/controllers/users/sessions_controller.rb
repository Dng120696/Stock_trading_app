class Users::SessionsController < Devise::SessionsController
  def create
      if admin_user_signed_in?
        sign_out(current_admin_user) # Sign out admin
      end
      super
  end
end
