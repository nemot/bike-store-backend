class AddSourceToLineItem < ActiveRecord::Migration[8.0]
  def change
    add_column :line_items, :source_id, :bigint
    add_column :line_items, :source_type, :string

    remove_column :line_items, :product_id
  end
end
