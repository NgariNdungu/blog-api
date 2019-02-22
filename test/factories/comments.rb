FactoryBot.define do
  factory :comment do
    body { "Awwwesome" }
    post 
    commenter

    factory :empty_comment do
      body {nil}
    end
  end

end
