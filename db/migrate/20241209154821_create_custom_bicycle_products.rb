class CreateCustomBicycleProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :custom_bicycle_products do |t|
      t.integer :product_id, null: false
      t.integer :custom_bicycle_id, null: false
      t.timestamps
    end
  end
end
