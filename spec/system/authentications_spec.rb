require 'rails_helper'

RSpec.describe "Authentication", type: :system do
  it "allows a user to register and confirms the email" do
    sign_up('newuser@example.com', 'password', 'Patrick', 'Nebab')
    expect(page).to have_content('A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.',wait: 10)

    confirmation_email = ActionMailer::Base.deliveries.last
    confirmation_link = extract_confirmation_link(confirmation_email)
    visit confirmation_link
    expect(page).to have_content('Your email address has been successfully confirmed.')
    visit new_user_session_path

    log_in("newuser@example.com","password")
    expect(page).to have_content('Signed in successfully.',wait:30)

  end

  private

  def sign_up(email, password, firstname, lastname, balance)
    visit new_user_registration_path
    fill_in 'Firstname', with: firstname
    fill_in 'Lastname', with: lastname
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password
    click_button 'Create Account'
  end

  def log_in(email, password)
    visit new_user_session_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Log in'
  end

  def extract_confirmation_link(email)
    email.body.to_s.scan(/http:\/\/.*confirmation_token=\w+/).last
  end
end
