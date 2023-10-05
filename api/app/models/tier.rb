# frozen_string_literal: true

class Tier < ApplicationRecord
  # Defaults:
  # id: 1, name: Bronze, min_spent_cents: 0
  # id: 2, name: Silver, min_spent_cents: 10_000
  # id: 3, name: Gold, min_spent_cents: 50_000

  has_many :loyalty_stats
end
