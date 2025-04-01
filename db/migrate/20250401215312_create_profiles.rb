class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :display_name
      t.text :bio
      t.string :avatar_url
      t.string :phone_number
      t.jsonb :address

      t.timestamps
    end
  end
end
