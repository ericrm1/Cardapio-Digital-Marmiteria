class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.string :customer_name, null: false
      t.string :customer_phone, null: false
      t.decimal :total, precision: 10, scale: 2, null: false, default: 0
      t.integer :status, null: false, default: 0

      t.timestamps

      t.check_constraint "total >= 0", name: "orders_total_non_negative"
    end
  end
end
