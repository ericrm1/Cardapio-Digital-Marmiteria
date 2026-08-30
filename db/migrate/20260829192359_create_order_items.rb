class CreateOrderItems < ActiveRecord::Migration[8.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :product_name, null: false
      t.decimal :unit_price, precision: 10, scale: 2, null: false, default: 0
      t.integer :quantity, null: false, default: 1
      t.text :observation
      t.decimal :subtotal, precision: 10, scale: 2, null: false, default: 0

      t.timestamps

      t.check_constraint "unit_price >= 0", name: "order_items_unit_price_non_negative"
      t.check_constraint "quantity > 0", name: "order_items_quantity_positive"
      t.check_constraint "subtotal >= 0", name: "order_items_subtotal_non_negative"
    end
  end
end
