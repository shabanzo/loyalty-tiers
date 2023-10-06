# frozen_string_literal: true

class ScopeLoyaltyStatsBasedOnYear < ActiveRecord::Migration[7.0]
  def change
    add_column :loyalty_stats, :year, :integer
    add_index :loyalty_stats, %i[customer_id year], unique: true
    remove_index :loyalty_stats, :customer_id
  end
end
