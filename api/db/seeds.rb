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
  CompletedOrder.delete_all
  LoyaltyStat.delete_all
  puts '=== Generating Dummy Orders for Customer ID: 1 ==='
  FactoryBot.create_list(
    :completed_order,
    50,
    customer_id: 1
  )
  puts '=== Generating Dummy Stats for Customer ID: 1 that match with Completed Orders ==='
  total_spending_this_year = CompletedOrder.where(
    'customer_id = ? AND date >= ?', 1, Date.current.beginning_of_year
  ).sum(:total_in_cents)

  total_spending_last_year = CompletedOrder.where(
    'customer_id = ? AND date >= ?', 1, Date.current.last_year.beginning_of_year
  ).sum(:total_in_cents)

  current_tier = Tier.where('min_spent_cents <= ?', total_spending_this_year + total_spending_last_year).last
  FactoryBot.create(
    :loyalty_stat,
    customer_id:       1,
    total_spent_cents: total_spending_this_year,
    year:              Date.current.year,
    tier:              current_tier
  )

  prev_tier = Tier.where('min_spent_cents <= ?', total_spending_last_year).last
  FactoryBot.create(
    :loyalty_stat,
    customer_id:       1,
    total_spent_cents: total_spending_last_year,
    year:              Date.current.last_year.year,
    tier:              prev_tier
  )

  puts '=== Generating Dummy Stats for Customer ID: 2 ==='
  FactoryBot.create(
    :loyalty_stat,
    customer_id:       2,
    total_spent_cents: 5000,
    year:              Date.current.last_year.year,
    tier_id:           1
  )
  FactoryBot.create(
    :loyalty_stat,
    customer_id:       2,
    total_spent_cents: 10_000,
    year:              Date.current.year,
    tier_id:           2
  )

  puts '=== Generating Dummy Stats for Customer ID: 3 ==='
  FactoryBot.create(
    :loyalty_stat,
    customer_id:       3,
    total_spent_cents: 15_000,
    year:              Date.current.last_year.year,
    tier_id:           2
  )
  FactoryBot.create(
    :loyalty_stat,
    customer_id:       3,
    total_spent_cents: 0,
    year:              Date.current.year,
    tier_id:           2
  )

  puts '=== Generating Dummy Stats for Customer ID: 4 ==='
  FactoryBot.create(
    :loyalty_stat,
    customer_id:       4,
    total_spent_cents: 40_000,
    year:              Date.current.last_year.year,
    tier_id:           3
  )
  FactoryBot.create(
    :loyalty_stat,
    customer_id:       4,
    total_spent_cents: 15_000,
    year:              Date.current.year,
    tier_id:           3
  )
end
