require 'rails_helper'

RSpec.describe WikisController, type: :controller do
  let(:title) { Faker::Lorem.sentence }
  let(:body) { Faker::Lorem.paragraph }
  let(:my_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:my_wiki) { create(:wiki, user: my_user) }

context "member user doing CRUD on a wiki they down" do
  before do
      @user = my_user
      sign_in @user
    end

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "renders the #new view" do
      get :new
      expect(response).to render_template :new
    end

    it "instantiates @wiki" do
      get :new
      expect(assigns(:wiki)).not_to be_nil
    end
  end

  describe "POST create" do
    it "increases the number of Wiki by 1" do
      expect{post :create, wiki: {title: my_wiki.title, body: my_wiki.body}}.to change(Wiki,:count).by(1)
    end

    it "assigns the new wiki to @wiki" do
      post :create, wiki: {title: my_wiki.title, body: my_wiki.body }
      expect(assigns(:wiki)).to eq Wiki.last
    end

    it "redirects to the new post" do
      post :create, wiki: {title: my_wiki.title, body: my_wiki.body }
      expect(response).to redirect_to Wiki.last
    end
  end
end

  #context "guest" do
  #  describe "GET show" do
  #    it "returns http success" do
  #      get :show, id: my_wiki.id
  #      expect(response).to have_http_status(:success)
  #    end

  #    it "renders the #show view" do
  #      get :show, id: my_wiki.id
  #      expect(response).to render_template :show
  #    end

  #    it "assigns my_wiki to @wiki" do
  #      get :show, id: my_wiki.id
  #      expect(assigns(:wiki)).to eq(my_wiki)
  #    end
  #  end

  #  describe "GET new" do
  #    it "returns http redirect" do
  #      get :new, id: my_wiki.id
  #      expect(response).to redirect_to(new_user_session_path)
  #    end
  #  end

  #  describe "POST create" do
  #    it "returns http redirect" do
  #      post :create, wiki: {}
  #end

  #describe "GET #create" do
  #  it "returns http success" do
  #    get :create
  #    expect(response).to have_http_status(302)
  #  end
  #end


end
