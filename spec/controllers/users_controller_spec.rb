require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets user as new blank User" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "@user.save validates" do
      before {post :create, user: Fabricate.attributes_for(:user)}
      it "saves user" do
        expect(User.count).to eq(1)
      end
      it "sets session with new user id" do
        expect(session[:user_id]).to eq(User.last.id)
      end
      it "redirects to home path" do
        expect(response).to redirect_to home_path
      end
    end
    context "@user.save does not validate" do
      before do
        User.create(email: '123@gmail.com', username: Faker::Name.name, password: 'password')
        post :create, user: { email: '123@gmail.com', username: Faker::Name.name, password: 'password' }
      end
      it "does not save @user" do
        expect(User.count).to eq(1)
      end
      it "renders :new template" do
        expect(response).to render_template :new
      end
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end
end