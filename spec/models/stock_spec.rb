require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:symbol) }
    it { should validate_presence_of(:company_name) }
    it { should validate_presence_of(:latest_price) }
    it { should validate_presence_of(:shares) }
    it { should validate_presence_of(:logo) }
    it { should validate_numericality_of(:shares).is_greater_than_or_equal_to(0) }
  end
end
