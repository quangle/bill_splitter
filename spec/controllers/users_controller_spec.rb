require 'rails_helper'

describe UsersController do
  let(:user) { create(:user)}
  before do
    sign_in user
  end

  let(:valid_attributes) {
    {
      email: Faker::Internet.email,
      password: "abcd1234",
      password_confirmation: "abcd1234"
    }
  }

  let(:invalid_attributes) {
    {
      email: "invalid email"
    }
  }

  describe "GET #index" do
    it "assigns all users as @users" do
      get :index
      expect(assigns(:users)).to eq [user]
    end
  end
end
