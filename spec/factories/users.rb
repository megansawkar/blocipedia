FactoryGirl.define do
  pw = Faker::Internet.password

  factory :user do
    email Faker::Internet.email
    username Faker::Lorem.word
    password pw
  end
end
