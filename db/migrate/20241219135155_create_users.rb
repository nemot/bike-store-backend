class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.column :name, :string
      t.column :email, :string
      t.column :address, :string
      t.timestamps
    end
  end
end
