# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

10.times do 
    content = Faker::Lorem.paragraph
    tweet = Tweet.create(content: content, user_id: 6)
end

10.times do 
    content = Faker::Lorem.paragraph
    tweet = Tweet.create(content: content, user_id: 2)
end

10.times do 
    content = Faker::Lorem.paragraph
    tweet = Tweet.create(content: content, user_id: 6)
end

10.times do 
    content = Faker::Lorem.paragraph
    tweet = Tweet.create(content: content, user_id: 2)
end

10.times do 
    content = Faker::Lorem.paragraph
    tweet = Tweet.create(content: content, user_id: 4)
end

10.times do 
    content = Faker::Lorem.paragraph
    tweet = Tweet.create(content: content, user_id: 3)
end

10.times do 
    content = Faker::Lorem.paragraph
    tweet = Tweet.create(content: content, user_id: 7)
end

10.times do 
    content = Faker::Lorem.paragraph
    tweet = Tweet.create(content: content, user_id: 4)
end

10.times do 
    content = Faker::Lorem.paragraph
    tweet = Tweet.create(content: content, user_id: 3)
end

10.times do 
    content = Faker::Lorem.paragraph
    tweet = Tweet.create(content: content, user_id: 7)
end

10.times do 
    content = Faker::Lorem.paragraph
    tweet = Tweet.create(content: content, user_id: 6)
end

10.times do 
    content = Faker::Lorem.paragraph
    tweet = Tweet.create(content: content, user_id: 2)
end

10.times do 
    content = Faker::Lorem.paragraph
    tweet = Tweet.create(content: content, user_id: 4)
end

10.times do 
    content = Faker::Lorem.paragraph
    tweet = Tweet.create(content: content, user_id: 3)
end

10.times do 
    content = Faker::Lorem.paragraph
    tweet = Tweet.create(content: content, user_id: 7)
end