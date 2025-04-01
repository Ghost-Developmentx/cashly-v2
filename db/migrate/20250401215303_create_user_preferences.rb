class CreateUserPreferences < ActiveRecord::Migration[8.0]
  def change
    create_table :user_preferences do |t|
      t.references :user, null: false, foreign_key: true
      t.string :currency
      t.string :language
      t.string :timezone
      t.jsonb :notification_preferences
      t.jsonb :privacy_settings
      t.jsonb :ui_preferences

      t.timestamps
    end
  end
end
