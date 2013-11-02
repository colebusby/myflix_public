require 'spec_helper'

feature 'user registers with a credit card', {js: true, vcr: true} do

  scenario "with valid user info and accepted card info" do
    visit register_path
    fill_in_user_info
    fill_in_credit_card_info
    click_button 'Sign Up'
    expect(page).to have_content "Lisa is now registered with MyFlix!"
  end

  scenario "with invalid user info and accepted card info" do
    visit register_path
    fill_in_user_info(nil)
    fill_in_credit_card_info
    click_button 'Sign Up'
    expect(page).to have_content "can't be blank"
  end

  scenario "with valid user info and declined card info" do
    visit register_path
    fill_in_user_info
    fill_in_credit_card_info('4000000000000002')
    click_button 'Sign Up'
    expect(page).to have_content "Your card was declined"
  end

  scenario "with valid user info and missing card info" do
    visit register_path
    fill_in_user_info
    fill_in_credit_card_info(nil)
    click_button 'Sign Up'
    expect(page).to have_content "This card number looks invalid"
  end

  def fill_in_user_info(email_address=Faker::Internet.email)
    fill_in 'Email Address', with: email_address
    fill_in 'Password', with: 'password'
    fill_in 'Full Name', with: 'Lisa'
  end

  def fill_in_credit_card_info(card_number='4242424242424242')
    fill_in 'Credit Card Number', with: card_number
    fill_in 'Security Code', with: '123'
    select '11 - November', from: 'date_month'
    select '2017', from: 'date_year'
  end
end