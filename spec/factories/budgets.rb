FactoryBot.define do
  factory :budget do
    user { nil }
    category { nil }
    name { "MyString" }
    amount { "9.99" }
    period { "MyString" }
    start_date { "2025-04-01" }
    end_date { "2025-04-01" }
    status { "MyString" }
    rollover_enabled { false }
  end
end
