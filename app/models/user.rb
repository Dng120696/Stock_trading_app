class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:confirmable
  enum status: {pending: 0, approved: 1 }
  after_create :send_status_email,:send_admin_notification
  has_many :transactions
  has_many :stocks, through: :transactions

  private

  def send_status_email
      UserMailer.newtrader_pending_email(self).deliver_now
  end
  def send_admin_notification
    AdminMailer.new_user_notification(AdminUser.first).deliver_now
  end

end
