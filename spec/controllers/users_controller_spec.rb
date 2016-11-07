require 'rails_helper'
require 'faker'

RSpec.describe UsersController, type: :controller do
  let(:new_user_attributes) do
    {
      email: Faker::Internet.email,
      username: Faker::Internet.word,
      password: Faker::Internet.password
    }
  end

  describe "GET show" do

    it "returns http success" do
      get :show
      expect(response).to redirect_to user_session_path
    end
  end
end
