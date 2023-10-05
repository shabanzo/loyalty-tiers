# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    customer_id { Faker::Number.number(digits: 3) }
    total_in_cents { 1000 }
    date { Date.today }
  end
end
