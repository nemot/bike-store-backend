class CreateLineItems < ActiveRecord::Migration[8.0]
  def change
    create_table :line_items do |t|
      t.integer :product_id
      t.belongs_to :holder, polymorphic: true
      t.integer :quantity
      t.decimal :price
      t.timestamps
    end
  end
end
