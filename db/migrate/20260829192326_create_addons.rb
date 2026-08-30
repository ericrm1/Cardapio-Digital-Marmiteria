class CreateAddons < ActiveRecord::Migration[8.1]
  def change
    create_table :addons do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps

      t.check_constraint "price >= 0", name: "addons_price_non_negative"
    end
  end
end
