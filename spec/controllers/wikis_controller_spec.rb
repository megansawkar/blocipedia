require 'rails_helper'

RSpec.describe WikisController, type: :controller do
  let(:user) { User.create!(email: "mwelch122@gmail.com", password: "password")}
  let(:my_wiki) { Wiki.create!(title: "New Wiki Title", body: "New Wiki Body", user: user, private: false)}

  describe "GET #create" do
    it "returns http success" do
      get :create
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #update" do
    it "returns http success" do
      get :update
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      get :destroy
      expect(response).to have_http_status(:success)
    end
  end

end
