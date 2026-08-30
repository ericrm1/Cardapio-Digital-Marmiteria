class CreateProductAddons < ActiveRecord::Migration[8.1]
  def change
    create_table :product_addons do |t|
      t.references :product, null: false, foreign_key: true
      t.references :addon, null: false, foreign_key: true

      t.timestamps
    end

    add_index :product_addons, [ :product_id, :addon_id ], unique: true
  end
end
