class Account < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :transactions, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :account_type, presence: true
  validates :balance, presence: true

  # Scopes
  scope :active, -> { where(status: "active") }
  scope :by_type, ->(type) { where(account_type: type) }

  # Methods
  def update_balance!
    calculated_balance = transactions.where(status: "posted").sum(:amount)
    update(balance: calculated_balance)
  end
end
