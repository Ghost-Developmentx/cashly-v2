FactoryBot.define do
  factory :user_preference do
    user { nil }
    currency { "MyString" }
    language { "MyString" }
    timezone { "MyString" }
    notification_preferences { "" }
    privacy_settings { "" }
    ui_preferences { "" }
  end
end
