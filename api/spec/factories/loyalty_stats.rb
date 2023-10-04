# frozen_string_literal: true

FactoryBot.define do
  factory :loyalty_stat do
    customer
    tier
    total_spent_cents { 1000 }
  end
end
