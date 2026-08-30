class CreateRestaurants < ActiveRecord::Migration[8.1]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :whatsapp, null: false
      t.boolean :active, null: false, default: true
      t.boolean :accepting_orders, null: false, default: true

      t.timestamps
    end

    add_index :restaurants, :slug, unique: true
  end
end
