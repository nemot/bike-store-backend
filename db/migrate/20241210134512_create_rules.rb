class CreateRules < ActiveRecord::Migration[8.0]
  def change
    create_table :rules do |t|
      t.jsonb :conditions, null: false, default: {}
      t.jsonb :effects, null: false, default: {}
      t.timestamps
    end
  end
end
