# frozen_string_literal: true

FactoryBot.define do
  factory :loyalty_stat do
    customer_id { Faker::Number.unique.number(digits: 3) }
    year { Faker::Number.unique.number(digits: 4) }
    tier_id { rand(1..3) }
    total_spent_cents { 1000 }
  end
end
