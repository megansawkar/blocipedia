require 'rubygems'
require 'faker'

5.times do
  user = User.create(
  email: Faker::Internet::email,
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

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
