require 'spec_helper'

feature 'user interacts with queue items' do


  scenario 'user adds and reorders videos in the queue' do
    action = Fabricate(:category, name: 'Action')
    firefly = Fabricate(:video, title: 'Firefly', description: 'Space western.', categories: [action])
    monk = Fabricate(:video, title: 'Monk', categories: [action])
    continuum = Fabricate(:video, title: 'Continuum', categories: [action])

    sign_in_with_authenticated_user
    visit home_path
    find("a[href='/videos/#{firefly.id}']").click
    expect(page).to have_content firefly.description

    find("a[href='/queue_items?video_id=#{firefly.id}']").click
    expect(page).to have_content 'List Order'
    expect(page).to have_content firefly.title

    click_link 'Firefly'
    expect(page).to have_no_content '+ My Queue'

    click_link 'Videos'
    find("a[href='/videos/#{monk.id}']").click
    find("a[href='/queue_items?video_id=#{monk.id}']").click
    click_link 'Videos'
    find("a[href='/videos/#{continuum.id}']").click
    find("a[href='/queue_items?video_id=#{continuum.id}']").click
    expect(page).to have_content 'Monk'
    expect(page).to have_content 'Continuum'

    fill_in "video_#{firefly.id}", with: '8'
    fill_in "video_#{monk.id}", with: '2'
    fill_in "video_#{continuum.id}", with: '5'
    click_button 'Update Instant Queue'
    expect(find("#video_#{firefly.id}").value).to eq("3")
    expect(find("#video_#{monk.id}").value).to eq("1")
    expect(find("#video_#{continuum.id}").value).to eq("2")
  end
end