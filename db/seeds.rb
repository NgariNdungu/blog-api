# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create(username: "firstUser", full_name: "First User", password: "superstrongpassword")

5.times do |i|
  user.posts.create(title: "Post ##{i}", text: "with text")
end

commenter = User.create(username: "commentUser", full_name: "Comment User", password: "superstrongpassword")

Post.all.each do |post|
  2.times do |i|
    post.comments.create(body: "comment ##{i}", commenter: commenter)
  end
end
