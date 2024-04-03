class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:confirmable
  enum role: { trader: 0 }
  enum status: {pending: 0, approved: 1 }
  after_create :send_status_email

  def send_status_email
    if status == :pending
      UserMailer.pending_email(self).deliver_now
    end
  end


end
