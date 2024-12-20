class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.column :status, :string, default: 'cart'
      t.column :shipping_address, :string
      t.column :details, :text
      t.belongs_to :user
      t.timestamps
    end
  end
end
