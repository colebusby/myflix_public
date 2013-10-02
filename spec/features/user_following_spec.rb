require 'spec_helper'

feature 'user follows another user' do

  scenario 'user follows a reviewer and then unfollows them' do
    john = Fabricate(:user, username: 'John Doe')
    action = Fabricate(:category, name: 'Action')
    continuum = Fabricate(:video, title: 'Continuum', categories: [action])
    johns_review = Fabricate(:review, user: john, video: continuum)

    sign_in_with_authenticated_user
    visit home_path
    click_link 'Videos'
    expect(page).to have_content 'Action'

    find("a[href='/videos/#{continuum.id}']").click
    expect(page).to have_content continuum.description

    click_link 'John Doe'
    expect(page).to have_content "John Doe's video collections"

    click_link 'Follow'
    click_link 'People'
    expect(page).to have_content "People I Follow"
    expect(page).to have_content "John Doe"

    click_link 'remove John Doe'
    expect(page).to have_no_content 'John Doe'
  end
end