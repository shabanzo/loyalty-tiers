# frozen_string_literal: true

FactoryBot.define do
  factory :tier do
    name { 'Bronze' }
    min_spent_cents { 0 }
  end
end
