# frozen_string_literal: true

FactoryBot.define do
  factory :loyalty_stat do
    customer_id { Faker::Number.unique.number(digits: 3) }
    tier
    total_spent_cents { 1000 }
  end
end
