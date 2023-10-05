# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :customer_id
      t.integer :total_in_cents
      t.datetime :date

      t.timestamps
    end
    add_index :orders, :date
    add_index :orders, :customer_id
  end
end
