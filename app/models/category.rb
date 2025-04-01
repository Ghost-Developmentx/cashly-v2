class Category < ApplicationRecord
  # Associations
  belongs_to :parent, class_name: "Category", optional: true
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  has_many :transactions
  has_many :budgets

  # Validations
  validates :name, presence: true, uniqueness: { scope: :parent_id }

  # Scopes
  scope :top_level, -> { where(parent_id: nil) }
  scope :by_type, ->(type) { where(category_type: type) }

  # Methods
  def all_transactions
    category_ids = [ id ] + subcategories.pluck(:id)
    Transaction.where(category_id: category_ids)
  end
end
