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
    let!(:bronze_without_spending) do
      create(:loyalty_stat, tier_id: 1, total_spent_cents: 0)
    end
    let!(:bronze_with_spending_equal_silver) do
      create(:loyalty_stat, tier_id: 1, total_spent_cents: 10_000)
    end
    let!(:bronze_with_spending_equal_gold) do
      create(:loyalty_stat, tier_id: 1, total_spent_cents: 50_000)
    end
    let!(:silver_without_spending) do
      create(:loyalty_stat, tier_id: 2, total_spent_cents: 0)
    end
    let!(:silver_with_spending_equal_silver) do
      create(:loyalty_stat, tier_id: 2, total_spent_cents: 10_000)
    end
    let!(:silver_with_spending_equal_gold) do
      create(:loyalty_stat, tier_id: 2, total_spent_cents: 50_000)
    end
    let!(:gold_without_spending) do
      create(:loyalty_stat, tier_id: 3, total_spent_cents: 0)
    end
    let!(:gold_with_spending_equal_silver) do
      create(:loyalty_stat, tier_id: 3, total_spent_cents: 10_000)
    end
    let!(:gold_with_spending_equal_gold) do
      create(:loyalty_stat, tier_id: 3, total_spent_cents: 50_000)
    end

    it 'updates loyalty stats in batches' do
      annual_generator.call

      expect(bronze_without_spending.reload.tier_id).to eq(1)
      expect(bronze_with_spending_equal_silver.reload.tier_id).to eq(2)
      expect(bronze_with_spending_equal_gold.reload.tier_id).to eq(3)
      expect(silver_without_spending.reload.tier_id).to eq(1)
      expect(silver_with_spending_equal_silver.reload.tier_id).to eq(2)
      expect(silver_with_spending_equal_gold.reload.tier_id).to eq(3)
      expect(gold_without_spending.reload.tier_id).to eq(1)
      expect(gold_with_spending_equal_silver.reload.tier_id).to eq(2)
      expect(gold_with_spending_equal_gold.reload.tier_id).to eq(3)
    end
  end
end
