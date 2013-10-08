require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets user as new blank User" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with authenticated user" do
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

    context "without authenticated user" do
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

    context "sending email" do
      after { ActionMailer::Base.deliveries.clear }

      it "sends out email to the user with valid inputs" do
        post(:create, user: { email: "lisa@example.com", password: "password", username: "Lisa" })
        expect(ActionMailer::Base.deliveries.last.to).to eq(["lisa@example.com"])
      end

      it "send out email containing the user's name with valid inputs" do
        post(:create, user: { email: "lisa@example.com", password: "password", username: "Lisa" })
        expect(ActionMailer::Base.deliveries.last.body).to include("Lisa")
      end

      it "does not send email with invalid inputs" do
        post(:create, user: { email: "lisa@example.com", username: "Lisa" })
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end
  end

  describe "GET show" do
    context "with authenticated user" do

      before { set_current_user }

      it "renders show page of selected user" do
        lisa = current_user
        get :show, id: lisa.id
        expect(response).to render_template :show
      end

      it "sets @user to selected user when selected is current user" do
        lisa = current_user
        get :show, id: lisa.id
        expect(assigns(:user)).to eq(lisa)
      end

      it "sets @user to selected user when selected is not current user" do
        lisa = current_user
        alice = Fabricate(:user)
        get :show, id: alice.id
        expect(assigns(:user)).to eq(alice)
      end
    end
    context "without authenticated user" do

      it "should redirect to sign in page" do
        alice = Fabricate(:user)
        get :show, id: alice.id
        expect(response).to redirect_to signin_path
      end
    end
  end
end