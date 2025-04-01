class CreateFinConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :fin_conversations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :status
      t.jsonb :context
      t.jsonb :metadata

      t.timestamps
    end
  end
end
