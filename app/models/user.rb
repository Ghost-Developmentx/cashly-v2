class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable, :omniauthable

  # Associations
  has_many :fin_conversations, dependent: :destroy
  has_many :accounts, dependent: :destroy
  has_many :transactions, through: :accounts
  has_many :budgets, dependent: :destroy
  has_one :user_preference, dependent: :destroy
  has_one :profile, dependent: :destroy

  # Callbacks
  after_create :create_default_user_preference
  after_create :create_default_profile

  private

  def create_default_user_preference
    create_user_preference(
      currency: "USD",
      language: "en",
      timezone: "UTC",
      notification_preferences: {},
      privacy_settings: {},
      ui_preferences: {}
    )
  end

  def create_default_profile
    create_profile(
      first_name: "",
      last_name: "",
      display_name: email.split("@").first,
      bio: "",
      avatar_url: "",
      phone_number: "",
      address: {}
    )
  end
end
