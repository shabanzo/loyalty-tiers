# frozen_string_literal: true

class RenameCustomerStatsToLoyaltyStats < ActiveRecord::Migration[7.0]
  def change
    rename_table :customer_stats, :loyalty_stats
  end
end
