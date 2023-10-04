# frozen_string_literal: true

class CreateCustomerStats < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_stats do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :tier, null: false, foreign_key: true

      t.integer :total_spent_cents

      t.timestamps
    end
  end
end
