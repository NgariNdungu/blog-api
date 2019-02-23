FactoryBot.define do
  factory :user, aliases: [:author, :commenter] do
    sequence(:username, "a") { |a| "guy#{a}" }
    password { "superstrongpassword" }
    full_name { "but of course guy" }
  end
end
