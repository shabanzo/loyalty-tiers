# frozen_string_literal: true

class CreateCustomerStats < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_stats do |t|
      t.integer :customer_id
      t.references :tier, null: false, foreign_key: true

      t.integer :total_spent_cents

      t.timestamps
    end
    add_index :customer_stats, :customer_id
  end
end
