class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :account_type
      t.string :institution
      t.string :account_number_last_four
      t.decimal :balance, precision: 10, scale: 2
      t.decimal :available_balance, precision: 10, scale: 2
      t.string :currency
      t.string :status
      t.string :external_id
      t.jsonb :metadata

      t.timestamps
    end
  end
end
