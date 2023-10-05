# frozen_string_literal: true

class AddDefaultValuesToLoyaltyStat < ActiveRecord::Migration[7.0]
  def change
    change_column_default :loyalty_stats, :tier_id, 1
    change_column_default :loyalty_stats, :total_spent_cents, 0
  end
end
