class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.references :parent, foreign_key: { to_table: :categories }, null: true
      t.string :name
      t.text :description
      t.string :category_type
      t.string :icon
      t.string :color
      t.boolean :is_system, default: false

      t.timestamps
    end
  end
end
