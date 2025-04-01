class Transaction < ApplicationRecord
  # Associations
  belongs_to :account
  belongs_to :category, optional: true
  has_many :fin_message_references, as: :referenced_entity, dependent: :destroy

  # Validations
  validates :amount, presence: true
  validates :transaction_date, presence: true

  # Scopes
  scope :recent, -> { order(transaction_date: :desc) }
  scope :income, -> { where("amount > 0") }
  scope :expense, -> { where("amount < 0") }
  scope :by_date_range, ->(start_date, end_date) { where(transaction_date: start_date..end_date) }

  # Callbacks
  after_save :update_account_balance

  private

  def update_account_balance
    account.update_balance!
  end
end
