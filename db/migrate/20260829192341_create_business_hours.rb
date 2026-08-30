class CreateBusinessHours < ActiveRecord::Migration[8.1]
  def change
    create_table :business_hours do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.integer :day_of_week, null: false
      t.time :open_time
      t.time :close_time
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :business_hours, [ :restaurant_id, :day_of_week ], unique: true
  end
end
