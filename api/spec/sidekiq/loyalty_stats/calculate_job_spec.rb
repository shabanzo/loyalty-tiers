# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoyaltyStats::CalculateJob, type: :job do
  describe '#perform' do
    context 'when the stat is existed with total_spent_cents 500' do
      context 'when get an new order with totalInCents = 50' do
        let(:loyalty_stat) do
          create(
            :loyalty_stat,
            tier_id:           1,
            customer_id:       1,
            year:              Date.current.year,
            total_spent_cents: 500
          )
        end

        before do
          loyalty_stat
        end

        it 'updates total spent' do
          expect {
            described_class.new.perform(loyalty_stat.customer_id, 50)
          }.to change {
            loyalty_stat.reload.total_spent_cents
          }.from(500).to(550)
        end

        it 'keeps the tier' do
          expect {
            described_class.new.perform(loyalty_stat.customer_id, 50)
          }.not_to(change do
            loyalty_stat.reload.tier.name
          end)
        end
      end

      context 'when get an new order with totalInCents = 9_500' do
        let(:loyalty_stat) do
          create(
            :loyalty_stat,
            tier_id:           1,
            customer_id:       1,
            year:              Date.current.year,
            total_spent_cents: 500
          )
        end

        before do
          loyalty_stat
        end

        it 'updates total spent' do
          expect {
            described_class.new.perform(loyalty_stat.customer_id, 9_500)
          }.to change {
            loyalty_stat.reload.total_spent_cents
          }.from(500).to(10_000)
        end

        it 'updates the tier' do
          expect {
            described_class.new.perform(loyalty_stat.customer_id, 9_500)
          }.to change {
            loyalty_stat.reload.tier.name
          }.from('Bronze').to('Silver')
        end
      end
    end

    context 'when the stat is not existed' do
      context 'when get an new order with totalInCents = 500' do
        before do
          described_class.new.perform(2, 500)
        end

        it 'creates a loyalty stats and updates total spent' do
          loyalty_stat = LoyaltyStat.find_by(customer_id: 2)
          expect(loyalty_stat.total_spent_cents).to eq(500)
        end

        it 'keeps the default one' do
          loyalty_stat = LoyaltyStat.find_by(customer_id: 2)
          expect(loyalty_stat.tier.name).to eq('Bronze')
        end
      end

      context 'when get an new order with totalInCents = 10_000' do
        before do
          described_class.new.perform(2, 10_000)
        end

        it 'creates a loyalty stats and updates total spent' do
          loyalty_stat = LoyaltyStat.find_by(customer_id: 2)
          expect(loyalty_stat.total_spent_cents).to eq(10_000)
        end

        it 'updates the tier from the default one (Bronze to Silver)' do
          loyalty_stat = LoyaltyStat.find_by(customer_id: 2)
          expect(loyalty_stat.tier.name).to eq('Silver')
        end
      end
    end
  end
end
