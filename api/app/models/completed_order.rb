# frozen_string_literal: true

class CompletedOrder < ApplicationRecord
  validates :customer_id, presence: true
  validates :order_id, presence: true, uniqueness: { scope: :customer_id }
end
