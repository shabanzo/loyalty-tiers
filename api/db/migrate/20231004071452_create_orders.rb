class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.integer :total_in_cents
      t.datetime :date

      t.timestamps
    end
    add_index :orders, :date
  end
end
