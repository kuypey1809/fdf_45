require "rails_helper"

RSpec.describe UsersController, type: :controller do
  user = FactoryBot.build_stubbed :user
  user1 = FactoryBot.create :user1
  user2 = FactoryBot.create :user1

  describe "GET #index not logged in" do
    it "should redirect index when not logged in" do
      visit users_path
      expect(page).to have_current_path login_path
    end
  end

  describe "GET #index logged in" do
    before {login user1}
    context "should render index user" do
      before {visit users_path}
      it {is_expected.to render_template :index}
    end
  end

  describe "GET #show/:id" do
    it "should render show user" do
      visit user_path(user1.id)
      expect(page).to render_template :show
    end
  end

  describe "GET #new" do
    it "should get new user" do
      visit signup_path
      expect(page).to render_template :new
    end
  end

  describe "GET #edit" do
    it "should redirect edit when not logged in" do
      visit edit_user_path user1.id
      expect(page).to have_current_path login_path
    end
    it "should redirect edit when logged in as wrong user" do
      login(user2)
      visit edit_user_path user1.id
      expect(page).to have_current_path root_path
    end
    it "should render edit page" do
      login user1
      visit edit_user_path user1.id
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "create new user" do
        user_attributes = FactoryBot.attributes_for(:user1)
        expect {
          post :create, params: {user: user_attributes}
        }.to change(User, :count).by(1)
      end
      it "permit params" do
        params = {
          user: {
            name: "John",
            email: "johndoe@example.com",
            address: "123123qwweqwe",
            phone: "0914112828",
            password: "password",
            password_confirmation: "password"}}
        is_expected.to permit(:name, :email, :address, :phone, :password, :password_confirmation).for(:create, params: params).on(:user)
      end
    end
    context "with invalid attributes" do
      user_attributes = FactoryBot.attributes_for(:user2)
      it "does not save new user" do
        expect{
          post :create, params: {user: user_attributes}
        }.to_not change(User,:count)
      end
      it "re-renders the new method" do
        post :create, params: {user: user_attributes}
        expect(response).to render_template :new
      end
    end
  end

  describe "routes" do
    it {is_expected.to route(:get, "/users").to(action: :index)}
    it {is_expected.to route(:get, "/users/1").to(action: :show, id: 1)}
    it {is_expected.to route(:get, "/signup").to(action: :new)}
    it {is_expected.to route(:get, "/users/1/edit").to(action: :edit, id: 1)}
    it {is_expected.to route(:post, "/signup").to(action: :create)}
    it {is_expected.to route(:patch, "/users/1").to(action: :update, id: 1)}
    it {is_expected.to route(:delete, "/users/1").to(action: :destroy, id: 1)}
  end
end
