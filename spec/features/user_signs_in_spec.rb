require 'spec_helper'

feature 'signing in' do

  background { User.create(email: 'lisa@fakemail.com', username: 'Lisa', password: 'password') }

  scenario 'sign in by registed user' do
    visit signin_path
    fill_in 'Email Address', :with =>'lisa@fakemail.com'
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'
    expect(page).to have_content 'Welcome, Lisa'
  end
end