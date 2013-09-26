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