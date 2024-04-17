
FactoryBot.define do
  factory :admin_user do
    email { 'admin123@gmail.com' }
    password { 'password123' }
    firstname { 'Pat' }
    lastname { 'Nebab' }
  end
end
