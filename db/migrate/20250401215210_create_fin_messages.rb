class CreateFinMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :fin_messages do |t|
      t.references :fin_conversation, null: false, foreign_key: true
      t.text :content
      t.string :role
      t.jsonb :metadata

      t.timestamps
    end
  end
end
