class AddDefailtValuesToLineItems < ActiveRecord::Migration[8.0]
  def change
    change_column :line_items, :quantity, :integer, default: 0, null: false
    change_column :line_items, :price, :decimal, default: 0.00, null: false
  end
end
