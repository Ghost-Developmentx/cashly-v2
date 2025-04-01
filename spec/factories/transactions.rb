FactoryBot.define do
  factory :transaction do
    account { nil }
    category { nil }
    amount { "9.99" }
    description { "MyString" }
    merchant_name { "MyString" }
    transaction_date { "2025-04-01" }
    posted_date { "2025-04-01" }
    status { "MyString" }
    transaction_type { "MyString" }
    is_recurring { false }
    external_id { "MyString" }
    metadata { "" }
  end
end
