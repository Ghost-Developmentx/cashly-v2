FactoryBot.define do
  factory :fin_message do
    fin_conversation { nil }
    content { "MyText" }
    role { "MyString" }
    metadata { "" }
  end
end
