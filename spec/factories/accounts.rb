FactoryBot.define do
  factory :account do
    user { nil }
    name { "MyString" }
    account_type { "MyString" }
    institution { "MyString" }
    account_number_last_four { "MyString" }
    balance { "9.99" }
    available_balance { "9.99" }
    currency { "MyString" }
    status { "MyString" }
    external_id { "MyString" }
    metadata { "" }
  end
end
