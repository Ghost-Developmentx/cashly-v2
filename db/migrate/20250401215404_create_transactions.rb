class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.string :description
      t.string :merchant_name
      t.date :transaction_date
      t.date :posted_date
      t.string :status
      t.string :transaction_type
      t.boolean :is_recurring
      t.string :external_id
      t.jsonb :metadata

      t.timestamps
    end
  end
end
