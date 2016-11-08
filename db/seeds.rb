require 'rubygems'
require 'faker'

5.times do
  user = User.create(
  email: Faker::Internet::email,
  username: Faker::Lorem.word,
  password: Faker::Internet.password
  )
end

users = User.all

#create wikis
50.times do
  Wiki.create(
  user: users.sample,
  title: Faker::Lorem.sentence,
  body: Faker::Lorem.paragraph
  )
end

wikis = Wiki.all

standard = User.create!(
  email: 'standard@example.com',
  username: 'Standard User',
  password: 'helloworld',
  role: 'standard'
)

premium = User.create!(
  email: 'premium@example.com',
  username: 'Premium User',
  password: 'helloworld',
  role: 'premium'
)

admin = User.create!(
  email: 'admin@example.com',
  username: 'Admin User',
  password: 'helloworld',
  role: 'admin'
)

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
