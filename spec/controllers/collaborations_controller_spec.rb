require 'rails_helper'

RSpec.describe CollaborationsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_wiki) { create(:wiki, user: my_user) }
  let(:my_collaboration) { Collaboration.create!(user_id: my_user.id, wiki_id: my_wiki.id) }

  describe "GET #create" do
    it "returns http success" do
      get :create, user_id: my_user.id, wiki_id: my_wiki.id # rubocop:disable HttpPositionalArguments
      expect(response).to have_http_status(302)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      get :destroy, wiki_id: my_wiki.id, id: my_collaboration.id # rubocop:disable HttpPositionalArguments
      expect(response).to have_http_status(302)
    end
  end
end
