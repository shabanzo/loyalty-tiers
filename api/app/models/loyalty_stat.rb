# frozen_string_literal: true

class LoyaltyStat < ApplicationRecord
  belongs_to :tier

  validates :customer_id, presence: true, uniqueness: true

  scope :not_zero_total_spent_and_not_bronze, lambda {
    where.not(total_spent_cents: 0, tier_id: 1)
  }
end
