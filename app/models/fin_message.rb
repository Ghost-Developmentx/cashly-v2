class FinMessage < ApplicationRecord
  # Associations
  belongs_to :fin_conversation, touch: true
  has_many :fin_message_references, dependent: :destroy
  has_many :referenced_entities, through: :fin_message_references

  # Validations
  validates :content, presence: true
  validates :role, presence: true, inclusion: { in: %w[user assistant system] }

  # Scopes
  scope :chronological, -> { order(created_at: :asc) }
  scope :user_messages, -> { where(role: "user") }
  scope :assistant_messages, -> { where(role: "assistant") }

  # Methods
  def reference_entity(entity, reference_type = "mention")
    fin_message_references.create(
      referenced_entity: entity,
      reference_type: reference_type
    )
  end
end