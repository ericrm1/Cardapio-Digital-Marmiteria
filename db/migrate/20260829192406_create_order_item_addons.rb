class CreateOrderItemAddons < ActiveRecord::Migration[8.1]
  def change
    create_table :order_item_addons do |t|
      t.references :order_item, null: false, foreign_key: true
      t.references :addon, null: false, foreign_key: true
      t.string :addon_name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false, default: 0
      t.integer :quantity, null: false, default: 1
      t.decimal :subtotal, precision: 10, scale: 2, null: false, default: 0

      t.timestamps

      t.check_constraint "price >= 0", name: "order_item_addons_price_non_negative"
      t.check_constraint "quantity > 0", name: "order_item_addons_quantity_positive"
      t.check_constraint "subtotal >= 0", name: "order_item_addons_subtotal_non_negative"
    end
  end
end
