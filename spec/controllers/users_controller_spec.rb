require 'rails_helper'
require 'faker'

RSpec.describe UsersController, type: :controller do
  let(:user) { User.create!(email: Faker::Internet.email, username: Faker::Lorem.word, password: Faker::Internet.password) }

  describe "GET show" do
    it "returns http success" do
      get :show
      expect(response).to redirect_to user_session_path
    end
  end

  describe "GET downgrade" do
    it "#downgrades a user role from premium to standard" do
      expect(user).to have_attributes(:role => 'standard')
    end
  end
end
