
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    firstname { 'Pat' }
    lastname { 'Nebab' }
    balance { 20000 }
  end
end
