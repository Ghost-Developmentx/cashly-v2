class CreateBudgets < ActiveRecord::Migration[8.0]
  def change
    create_table :budgets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :name
      t.decimal :amount, precision: 10, scale: 2
      t.string :period
      t.date :start_date
      t.date :end_date
      t.string :status
      t.boolean :rollover_enabled

      t.timestamps
    end
  end
end
