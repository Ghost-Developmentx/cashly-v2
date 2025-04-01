FactoryBot.define do
  factory :category do
    parent { nil }
    name { "MyString" }
    description { "MyText" }
    category_type { "MyString" }
    icon { "MyString" }
    color { "MyString" }
    is_system { false }
  end
end
