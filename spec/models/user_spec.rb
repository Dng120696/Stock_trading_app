require 'rails_helper'

RSpec.describe User, type: :model do
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

  end
end
