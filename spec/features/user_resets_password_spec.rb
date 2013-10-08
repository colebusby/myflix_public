require 'spec_helper'

feature "user resets password" do
  scenario "user successfully resets the password" do
    lisa = Fabricate(:user, password: 'old_password')
    visit signin_path
    click_link 'Forgot Password?'
    fill_in 'Email Address', with: lisa.email
    click_button 'Send Email'

    open_email(lisa.email)
    binding.pry
    current_email.click_link('Reset Password')

    fill_in 'New Password', with: 'new_password'
    click_button 'Reset Password'

    fill_in 'Email Address', with: lisa.email
    fill_in 'Password', with: 'new_password'
    click_button 'Sign in'

    expect(page).to have_content "Welcome, #{lisa.username}"
  end
end