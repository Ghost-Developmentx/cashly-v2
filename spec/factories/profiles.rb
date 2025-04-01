FactoryBot.define do
  factory :profile do
    user { nil }
    first_name { "MyString" }
    last_name { "MyString" }
    display_name { "MyString" }
    bio { "MyText" }
    avatar_url { "MyString" }
    phone_number { "MyString" }
    address { "" }
  end
end
