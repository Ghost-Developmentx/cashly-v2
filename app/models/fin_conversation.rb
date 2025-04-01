class FinConversation < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :fin_messages, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :status, presence: true

  # Scopes
  scope :recent, -> { order(updated_at: :desc) }
  scope :active, -> { where(status: "active") }

  # Methods
  def add_message(content, role)
    fin_messages.create(content: content, role: role)
  end

  def context_summary
    # Generate a summary of the conversation context
    {
      conversation_id: id,
      message_count: fin_messages.count,
      last_message_at: fin_messages.maximum(:created_at),
      topics: extract_topics
    }
  end

  private

  def extract_topics
    # This would be implemented with NLP in the AI service
    # For now, just a placeholder
    %w[finance budgeting]
  end
end
