# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts '=== Generating Tier List ==='
Tier.create(id: 1, name: 'Bronze', min_spent_cents: 0) if Tier.where(id: 1).blank?
Tier.create(id: 2, name: 'Silver', min_spent_cents: 10_000) if Tier.where(id: 2).blank?
Tier.create(id: 3, name: 'Gold', min_spent_cents: 50_000) if Tier.where(id: 3).blank?

if Rails.env == 'development'
  puts '=== Generating Dummy Orders ==='
  FactoryBot.create_list(
    :completed_order,
    50,
    customer_id: 1
  )
end
