# frozen_string_literal: true

FactoryBot.define do
  factory :completed_order do
    customer_id { Faker::Number.unique.number(digits: 3) }
    order_id { Faker::Number.unique.number(digits: 3) }
    total_in_cents { Faker::Number.between(from: 1, to: 99_999) }
    date do
      Faker::Date.between(
        from: Date.current.last_year.beginning_of_year,
        to:   Date.current
      )
    end
  end
end
