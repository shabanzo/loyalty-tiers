# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    customer
    total_in_cents { 1000 }
    date { Date.today }
  end
end
