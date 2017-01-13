require 'rails_helper'
require 'spec_helper'

RSpec.describe WikisController, type: :controller do
  let(:title) { Faker::Lorem.sentence }
  let(:body) { Faker::Lorem.paragraph }
  let(:my_user) { create(:user) }
  let(:other_user) { User.create!(email: Faker::Internet.email, username: Faker::Lorem.word, password: Faker::Internet.password) }
  let(:my_wiki) { create(:wiki, user: my_user) }
  let(:my_private_wiki) { create(:wiki, private: true) }

  context "guest user doing CRUD" do
    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "does not include private wikis in @wikis" do
        get :index
        expect(assigns(:wikis)).not_to include(my_private_wiki)
      end
    end

    describe "GET show" do
      it "returns http found" do
        get :show, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to have_http_status(200)
      end

      it "redirects the #show view" do
        get :show, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to have_http_status(200)
      end
    end

    describe "GET new" do
      it "returns http redirect" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "POST create" do
      it "returns http redirect" do
        post :create, wiki: { title: title, body: body }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET edit" do
      it "returns http redirect" do
        get :edit, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "PUT update" do
      it "returns http redirect" do
        new_title = Faker::Lorem.sentence
        new_body = Faker::Lorem.paragraph

        put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "DELETE destroy" do
      it "returns http redirect" do
        delete :destroy, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "member user doing CRUD on a wiki they own" do
    before do
      @user = my_user
      sign_in @user
    end

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns Wiki.all to wiki" do
        get :index
        expect(assigns(:wikis)).to eq(Wiki.all) # ([my_wiki, my_private_wiki])
      end
    end

    describe "GET show" do
      it "returns http success" do
        get :show, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to have_http_status(:success)
      end

      it "renders the #show view" do
        get :show, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to render_template :show
      end

      it "assigns my_post to @post" do
        get :show, id: my_wiki.id # rubocop:disable HttpPositionalArguments
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
        expect { post :create, wiki: { title: 'Wiki title', body: 'Wiki body' } }.to change(Wiki, :count).by(1)
      end

      it "assigns the new wiki to @wiki" do
        post :create, wiki: { title: 'Wiki title', body: 'Wiki body' }
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "redirects to the new wiki" do
        post :create, wiki: { title: 'Wiki title', body: 'Wiki body' }
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to render_template :edit
      end

      it "assigns wiki to be updated to @wiki" do
        get :edit, id: my_wiki.id # rubocop:disable HttpPositionalArguments

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

        put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body }

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq my_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end

      it "redirects to the updated wiki" do
        new_title = Faker::Lorem.sentence
        new_body = Faker::Lorem.paragraph

        put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body }
        expect(response).to redirect_to my_wiki
      end
    end

    describe "DELETE destroy" do
      it "deletes the wiki" do
        delete :destroy, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        count = Wiki.where(id: my_wiki.id).size
        expect(count).to eq 0
      end

      it "redirects to posts index" do
        delete :destroy, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to redirect_to wikis_path
      end
    end
  end

  context "member user doing CRUD on a wiki they don't own" do
    before do
      @other_user = other_user
      sign_in @other_user
    end

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns Wiki.all to wiki" do
        get :index
        expect(assigns(:wikis)).to eq(Wiki.all) # ([my_wiki, my_private_wiki])
      end
    end

    describe "GET show" do
      it "returns http success" do
        get :show, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to have_http_status(:success)
      end

      it "renders the #show view" do
        get :show, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to render_template :show
      end

      it "assigns my_post to @post" do
        get :show, id: my_wiki.id # rubocop:disable HttpPositionalArguments
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
        expect { post :create, wiki: { title: 'Wiki title', body: 'Wiki body' } }.to change(Wiki, :count).by(1)
      end

      it "assigns the new wiki to @wiki" do
        post :create, wiki: { title: 'Wiki title', body: 'Wiki body' }
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "redirects to the new wiki" do
        post :create, wiki: { title: 'Wiki title', body: 'Wiki body' }
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to render_template :edit
      end

      it "assigns wiki to be updated to @wiki" do
        get :edit, id: my_wiki.id # rubocop:disable HttpPositionalArguments

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

        put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body }

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq my_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end

      it "redirects to the updated wiki" do
        new_title = Faker::Lorem.sentence
        new_body = Faker::Lorem.paragraph

        put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body }
        expect(response).to redirect_to my_wiki
      end
    end

    describe "DELETE destroy" do
      it "returns http redirect" do
        delete :destroy, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to redirect_to wikis_path
      end
    end
  end

  context "premium user doing CRUD on a wiki they don't own" do
    before do
      email = Faker::Internet.email
      username = Faker::Lorem.word
      password = Faker::Internet.password
      premium = User.create!(email: email, username: username, password: password, role: :premium)
      sign_in premium
    end

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns Wiki.all to wiki" do
        get :index
        expect(assigns(:wikis)).to eq(Wiki.all) # ([my_wiki, my_private_wiki])
      end
    end

    describe "GET show" do
      it "returns http success" do
        get :show, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to have_http_status(:success)
      end

      it "renders the #show view" do
        get :show, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to render_template :show
      end

      it "assigns my_wiki to @wiki" do
        get :show, id: my_wiki.id # rubocop:disable HttpPositionalArguments
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

      it "initializes @wiki" do
        get :new
        expect(assigns(:wiki)).not_to be_nil
      end
    end

    describe "POST create" do
      it "increases the number of Wiki by 1" do
        expect { post :create, wiki: { title: 'Wiki title', body: 'Wiki body' } }.to change(Wiki, :count).by(1)
      end

      it "assigns the new wiki to @wiki" do
        post :create, wiki: { title: 'Wiki title', body: 'Wiki body' }
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "redirects to the new wiki" do
        post :create, wiki: { title: 'Wiki title', body: 'Wiki body' }
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to render_template :edit
      end

      it "assigns wiki to be updated to @wiki" do
        get :edit, id: my_wiki.id # rubocop:disable HttpPositionalArguments

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

        put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body }

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq my_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end

      it "redirects to the updated wiki" do
        new_title = Faker::Lorem.sentence
        new_body = Faker::Lorem.paragraph

        put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body }
        expect(response).to redirect_to my_wiki
      end
    end

    describe "DELETE destroy" do
      it "returns http redirect" do
        delete :destroy, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to redirect_to wikis_path
      end
    end
  end

  context "admin user doing CRUD on a wiki they don't own" do
    before do
      email = Faker::Internet.email
      username = Faker::Lorem.word
      password = Faker::Internet.password
      admin = User.create!(email: email, username: username, password: password, role: :admin)
      sign_in admin
    end

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns Wiki.all to wiki" do
        get :index
        expect(assigns(:wikis)).to eq(Wiki.all) # ([my_wiki, my_private_wiki])
      end
    end

    describe "GET show" do
      it "returns http success" do
        get :show, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to have_http_status(:success)
      end

      it "renders the #show view" do
        get :show, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to render_template :show
      end

      it "assigns my_wiki to @wiki" do
        get :show, id: my_wiki.id # rubocop:disable HttpPositionalArguments
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

      it "initializes @wiki" do
        get :new
        expect(assigns(:wiki)).not_to be_nil
      end
    end

    describe "POST create" do
      it "increases the number of Wiki by 1" do
        expect { post :create, wiki: { title: 'Wiki title', body: 'Wiki body' } }.to change(Wiki, :count).by(1)
      end

      it "assigns the new wiki to @wiki" do
        post :create, wiki: { title: 'Wiki title', body: 'Wiki body' }
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "redirects to the new wiki" do
        post :create, wiki: { title: 'Wiki title', body: 'Wiki body' }
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to render_template :edit
      end

      it "assigns wiki to be updated to @wiki" do
        get :edit, id: my_wiki.id # rubocop:disable HttpPositionalArguments

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

        put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body }

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq my_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end

      it "redirects to the updated wiki" do
        new_title = Faker::Lorem.sentence
        new_body = Faker::Lorem.paragraph

        put :update, id: my_wiki.id, wiki: { title: new_title, body: new_body }
        expect(response).to redirect_to my_wiki
      end
    end

    describe "DELETE destroy" do
      it "deletes the wiki" do
        delete :destroy, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        count = Wiki.where(id: my_wiki.id).size
        expect(count).to eq 0
      end

      it "redirects to posts index" do
        delete :destroy, id: my_wiki.id # rubocop:disable HttpPositionalArguments
        expect(response).to redirect_to wikis_path
      end
    end
  end
end
