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

    describe "GET show" do
        it "returns http success" do
          get :show, id: my_wiki.id
          expect(response).to have_http_status(:success)
        end

        it "renders the #show view" do
          get :show, id: my_wiki.id
          expect(response).to render_template :show
        end

        it "assigns my_post to @post" do
          get :show, id: my_wiki.id
          expect(assigns(:wiki)).to eq(my_wiki)
        end
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
      expect{ post :create, wiki: {title: 'Wiki title', body: 'Wiki body'} }.to change(Wiki,:count).by(1)
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

  describe "GET edit" do
     it "returns http success" do
       get :edit, {id: my_wiki.id}
       expect(response).to have_http_status(:success)
     end

     it "renders the #edit view" do
       get :edit, {id: my_wiki.id}
       expect(response).to render_template :edit
     end

     it "assigns wiki to be updated to @wiki" do
       get :edit, {id: my_wiki.id}

       wiki_instance = assigns(:wiki)

       expect(wiki_instance.id).to eq my_wiki.id
       expect(wiki_instance.title).to eq my_wiki.title
       expect(wiki_instance.body).to eq my_wiki.body
     end
   end

   describe "PUT update" do
     it "updates wiki with expected attributes" do
       new_title = Faker::Lorem.sentence
       new_body = Faker::Lorem.paragraph

       put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}

       updated_wiki = assigns(:wiki)
       expect(updated_wiki.id).to eq my_wiki.id
       expect(updated_wiki.title).to eq new_title
       expect(updated_wiki.body).to eq new_body
     end

     it "redirects to the updated wiki" do
       new_title = Faker::Lorem.sentence
       new_body = Faker::Lorem.paragraph

       put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
       expect(response).to redirect_to my_wiki
     end
   end

   describe "DELETE destroy" do
     it "deletes the wiki" do
       delete :destroy, {id: my_wiki.id}
       count = Wiki.where({id: my_wiki.id}).size
       expect(count).to eq 0
     end

     it "redirects to posts index" do
       delete :destroy, {id: my_wiki.id}
       expect(response).to redirect_to wikis_path
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
