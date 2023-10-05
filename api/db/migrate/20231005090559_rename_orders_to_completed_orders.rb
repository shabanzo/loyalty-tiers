# frozen_string_literal: true

class RenameOrdersToCompletedOrders < ActiveRecord::Migration[7.0]
  def change
    rename_table :orders, :completed_orders
    add_column :completed_orders, :order_id, :string
  end
end
