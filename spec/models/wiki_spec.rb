require 'rails_helper'

RSpec.describe Wiki, type: :model do
  let(:user) { User.create!(email: "mwelch122@gmail.com", password: "password")}
  let(:wiki) { Wiki.create!(title: "New Wiki Title", body: "New Wiki Body", user: user, private: false)}

  it { is_expected.to belong_to(:user) }

  describe "attributes" do
    it "has title and body attributes" do
      expect(wiki).to have_attributes(title: "New Wiki Title", body: "New Wiki Body", private: false)
    end

    it "is public by default" do
      expect(wiki.private).to be(false)
    end
  end
end
