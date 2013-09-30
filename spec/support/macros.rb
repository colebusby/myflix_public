def set_current_user
  session[:user_id] = Fabricate(:user).id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def post_create_queue_item_with_video
  video = Fabricate(:video)
  post :create, video_id: video.id
end

# Feature Spec Helpers

def sign_in_with_authenticated_user
  User.create(email: 'lisa@fakemail.com', username: 'Lisa', password: 'password')
  visit signin_path
  fill_in 'Email Address', :with =>'lisa@fakemail.com'
  fill_in 'Password', :with => 'password'
  click_button 'Sign in'
end