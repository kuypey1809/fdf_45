class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :status, null: false, default: 0
      t.decimal :total_cost
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
