# frozen_string_literal: true

FactoryBot.define do
  factory :completed_order do
    customer_id { Faker::Number.unique.number(digits: 3) }
    order_id { Faker::Number.unique.number(digits: 3) }
    total_in_cents { Faker::Number.between(from: 1, to: 99_999) }
    date { Date.today }
  end
end
