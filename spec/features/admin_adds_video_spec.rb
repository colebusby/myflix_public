require 'spec_helper'

feature 'admin adds video' do

  scenario 'admin adds video and user can see video' do
    admin = Fabricate(:user, admin: true)
    comedy = Fabricate(:category, name: 'Comedy')
    sign_in(admin)
    visit new_admin_video_path

    fill_in 'Title', with: 'Monk'
    check 'Comedy'
    fill_in 'Description', with: "Funny show"
    attach_file 'Large cover', "spec/support/uploads/monk_large.jpg"
    attach_file 'Small cover', "spec/support/uploads/monk.jpg"
    fill_in 'Video Url', with: 'http://www.example.com/video.mp4'
    click_button 'Add Video'

    visit signout_path
    sign_in

    visit video_path(Video.first)
    expect(page).to have_selector "img[src='/uploads/monk_large.jpg']"
    expect(page).to have_selector "a[href='http://www.example.com/video.mp4']"
  end
end