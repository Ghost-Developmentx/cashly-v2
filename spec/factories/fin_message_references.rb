FactoryBot.define do
  factory :fin_message_reference do
    fin_message { nil }
    referenced_entity { nil }
    reference_type { "MyString" }
    metadata { "" }
  end
end
