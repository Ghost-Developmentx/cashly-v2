class CreateFinMessageReferences < ActiveRecord::Migration[8.0]
  def change
    create_table :fin_message_references do |t|
      t.references :fin_message, null: false, foreign_key: true
      t.references :referenced_entity, polymorphic: true, null: false
      t.string :reference_type
      t.jsonb :metadata

      t.timestamps
    end
  end
end
