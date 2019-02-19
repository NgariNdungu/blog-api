FactoryBot.define do
  factory :user, aliases: [:author, :commenter] do
    username { "some guy" }
    password { "superstrongpassword" }
    full_name { "but of course guy" }
  end
end
