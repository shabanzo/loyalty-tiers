# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoyaltyStats::AnnualGenerator do
  subject(:annual_generator) { described_class.new }

  context 'without any data' do
    it 'executes the task without errors' do
      expect { annual_generator.call }.not_to raise_error
    end
  end

  context 'with data' do
    let(:this_year) { Date.current.year }
    let(:next_year) { Date.current.next_year.year }
    let!(:bronze_without_spending) do
      create(:loyalty_stat, year: this_year, tier_id: 1, total_spent_cents: 0)
    end
    let!(:bronze_with_spending_equal_silver) do
      create(:loyalty_stat, year: this_year, tier_id: 1, total_spent_cents: 10_000)
    end
    let!(:bronze_with_spending_equal_gold) do
      create(:loyalty_stat, year: this_year, tier_id: 1, total_spent_cents: 50_000)
    end
    let!(:silver_without_spending) do
      create(:loyalty_stat, year: this_year, tier_id: 2, total_spent_cents: 0)
    end
    let!(:silver_with_spending_equal_silver) do
      create(:loyalty_stat, year: this_year, tier_id: 2, total_spent_cents: 10_000)
    end
    let!(:silver_with_spending_equal_gold) do
      create(:loyalty_stat, year: this_year, tier_id: 2, total_spent_cents: 50_000)
    end
    let!(:gold_without_spending) do
      create(:loyalty_stat, year: this_year, tier_id: 3, total_spent_cents: 0)
    end
    let!(:gold_with_spending_equal_silver) do
      create(:loyalty_stat, year: this_year, tier_id: 3, total_spent_cents: 10_000)
    end
    let!(:gold_with_spending_equal_gold) do
      create(:loyalty_stat, year: this_year, tier_id: 3, total_spent_cents: 50_000)
    end

    it 'creates loyalty stats in batches with adjusted tiers' do
      annual_generator.call

      new_bronze_without_spending = LoyaltyStat.find_by(
        year:        next_year,
        customer_id: bronze_without_spending.customer_id
      )
      expect(new_bronze_without_spending.tier_id).to eq(1)

      new_bronze_with_spending_equal_silver = LoyaltyStat.find_by(
        year:        next_year,
        customer_id: bronze_with_spending_equal_silver.customer_id
      )
      expect(new_bronze_with_spending_equal_silver.tier_id).to eq(2)

      new_bronze_with_spending_equal_gold = LoyaltyStat.find_by(
        year:        next_year,
        customer_id: bronze_with_spending_equal_gold.customer_id
      )
      expect(new_bronze_with_spending_equal_gold.tier_id).to eq(3)

      new_silver_without_spending = LoyaltyStat.find_by(
        year:        next_year,
        customer_id: silver_without_spending.customer_id
      )
      expect(new_silver_without_spending.tier_id).to eq(1)

      new_silver_with_spending_equal_silver = LoyaltyStat.find_by(
        year:        next_year,
        customer_id: silver_with_spending_equal_silver.customer_id
      )
      expect(new_silver_with_spending_equal_silver.tier_id).to eq(2)

      new_silver_with_spending_equal_gold = LoyaltyStat.find_by(
        year:        next_year,
        customer_id: silver_with_spending_equal_gold.customer_id
      )
      expect(new_silver_with_spending_equal_gold.tier_id).to eq(3)

      new_gold_without_spending = LoyaltyStat.find_by(
        year:        next_year,
        customer_id: gold_without_spending.customer_id
      )
      expect(new_gold_without_spending.tier_id).to eq(1)

      new_gold_with_spending_equal_silver = LoyaltyStat.find_by(
        year:        next_year,
        customer_id: gold_with_spending_equal_silver.customer_id
      )
      expect(new_gold_with_spending_equal_silver.tier_id).to eq(2)

      new_gold_with_spending_equal_gold = LoyaltyStat.find_by(
        year:        next_year,
        customer_id: gold_with_spending_equal_gold.customer_id
      )
      expect(new_gold_with_spending_equal_gold.tier_id).to eq(3)
    end
  end
end
