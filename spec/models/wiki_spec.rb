require 'rails_helper'

RSpec.describe Wiki, type: :model do
  let(:my_user) { create(:user)}
  let(:wiki) { create(:wiki, user: my_user) }

  it { is_expected.to belong_to(:user) }
  it{ is_expected.to have_many(:collaborations) }
  it{ is_expected.to have_many(:users) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_least(5) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_length_of(:body).is_at_least(5) }

  describe "attributes" do
    it "has title and body attributes" do
      expect(wiki).to have_attributes(title: wiki.title, body: wiki.body, user: my_user, private: false)
    end

    it "is public by default" do
      expect(wiki.private).to be(false)
    end
  end

  describe "scopes" do
    before do
      @public_wiki = Wiki.create!(title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph, user: my_user, private: false)
      @private_wiki = Wiki.create!(title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph, user: my_user, private: true)
    end

    describe "visible_to(user)" do
      it "returns all wikis if the user is present" do
        user = User.new
        expect(Wiki.visible_to(user)).to eq(Wiki.all)
      end

      it "returns only public wikis if user is nil" do
        expect(Wiki.visible_to(nil)).to eq([@public_wiki])
      end
    end
  end
end
