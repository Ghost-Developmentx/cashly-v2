class Budget < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :category, optional: true

  # Validations
  validates :name, presence: true
  validates :amount, presence: true
  validates :period, presence: true

  # Scopes
  scope :active, -> { where(status: "active") }
  scope :by_period, ->(period) { where(period: period) }

  # Methods
  def current_spending
    return 0 unless category

    # Determine a date range based on a period
    start_date, end_date = date_range_for_period

    # Get all transactions within this category (including subcategories)
    transactions = category.all_transactions

    # Sum expenses (negative amounts) within the date range
    transactions.expense.by_date_range(start_date, end_date).sum(:amount).abs
  end

  def remaining_amount
    amount - current_spending
  end

  def percentage_used
    return 0 if amount.zero?
    (current_spending / amount * 100).round(2)
  end

  private

  def date_range_for_period
    today = Date.today

    case period
    when "monthly"
      [ today.beginning_of_month, today.end_of_month ]
    when "quarterly"
      [ today.beginning_of_quarter, today.end_of_quarter ]
    when "annual"
      [ today.beginning_of_year, today.end_of_year ]
    else
      [ start_date, end_date || Date.today ]
    end
  end
end
