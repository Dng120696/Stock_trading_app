require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    AdminUser.create(email: 'admin@example.com', password: 'password123',firstname: 'Admin', lastname: '')
  end
  context 'validation tests' do
    it 'ensure first name presence' do
        user = User.new(lastname: 'Nebab',email:'example@example.com').save
        expect(user).to eq(false)
    end
    it 'ensure last name presence' do
      user = User.new(firstname: 'Patrick',email:'example@example.com').save
      expect(user).to eq(false)
    end
    it 'ensure email presence' do
      user = User.new(firstname: 'Patrick',lastname:'Nebab').save
      expect(user).to eq(false)
    end
    it 'sign up new trader/user' do
      user = User.new(firstname: 'Patrick', lastname: 'Nebab', balance: 20000, email: 'example@example.com', password: 'password123')
      user.skip_confirmation!
      expect(user.save).to eq(true)
    end
  end

  context 'scope tests' do
    before(:each) do
      User.create(firstname: 'John', lastname: 'Pat', email: 'example1@example.com', password: 'password123',balance:20000)
      User.create(firstname: 'Pat', lastname: 'John', email: 'example12@example.com', password: 'password123',balance:20000)
      User.create(firstname: 'dong', lastname: 'Pat', email: 'example123@example.com', password: 'password123',balance:20000,status: :approved)
    end

    it'user count is 3' do
      expect(User.count).to eq(3)
    end
  end
    describe 'callbacks' do
      describe '#send_status_email' do
        context 'when user status is pending' do
          it 'sends a new trader pending email' do
            user = User.create(firstname: 'Patrick', lastname: 'Nebab', balance: 20000, email: 'example@example.com', password: 'password123')
            expect(UserMailer).to receive(:newtrader_pending_email).with(user).and_return(double(deliver_now: true))
            user.send_status_email
          end
        end
      end

      describe '#send_admin_notification' do
        context 'when user status is pending' do
          it 'sends an admin notification email' do
            user = User.create(firstname: 'Patrick', lastname: 'Nebab', balance: 20000, email: 'example@example.com', password: 'password123')
            expect(AdminMailer).to receive(:new_user_notification).with(user, instance_of(AdminUser)).and_return(double(deliver_now: true))
            user.send_admin_notification
          end
        end

        context 'when user status is approved' do
          it 'does not send any email' do
            user = User.create(firstname: 'Patrick', lastname: 'Nebab', balance: 20000, email: 'example@example.com', password: 'password123', status: :approved)
            expect(AdminMailer).not_to receive(:new_user_notification)
        end
      end
    end
  end
end
