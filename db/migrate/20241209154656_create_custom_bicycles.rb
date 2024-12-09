class CreateCustomBicycles < ActiveRecord::Migration[8.0]
  def change
    create_table :custom_bicycles do |t|
      t.float :total_price
      t.string :user_id
      t.timestamps
    end
  end
end
