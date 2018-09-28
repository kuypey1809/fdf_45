class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :price, default: 0
      t.string :picture
      t.integer :average_rate
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
