# frozen_string_literal: true

FactoryBot.define do
  factory :completed_order do
    customer_id { Faker::Number.unique.number(digits: 3) }
    order_id { Faker::Number.unique.number(digits: 3) }
    total_in_cents { 1000 }
    date { Date.today }
  end
end
