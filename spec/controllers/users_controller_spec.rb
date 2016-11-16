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
end
