shared_examples "require_sign_in" do
  it "redirects to the sign in page" do
    clear_current_user
    action
    expect(response).to redirect_to signin_path
  end
end

shared_examples "generates_token" do
  it "generates a rondom token when object is created" do
    expect(object.token).to be_present
  end
end

shared_examples "require_admin" do
  it "redirects to user video page" do
    session[:user_id] = Fabricate(:user)
    action
    expect(response).to redirect_to home_path
  end

  it "sets error message" do
    session[:user_id] = Fabricate(:user)
    action
    expect(flash[:error]).to eq("You do not have access.")
  end
end