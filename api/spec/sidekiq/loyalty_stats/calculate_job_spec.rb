# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoyaltyStats::CalculateJob, type: :job do
  describe '#perform' do
    let(:loyalty_stat) do
      create(:loyalty_stat, customer_id: 1, total_spent_cents: 500)
    end

    context 'when the stat is existed' do
      before do
        loyalty_stat
      end

      it 'calculates loyalty stats and updates total spent' do
        expect {
          described_class.new.perform(loyalty_stat.customer_id, 1000)
        }.to change {
          loyalty_stat.reload.total_spent_cents
        }.from(500).to(1500)
      end
    end

    context 'when the stat is not existed' do
      it 'creates a loyalty stats and updates total spent' do
        described_class.new.perform(2, 1000)

        loyalty_stat = LoyaltyStat.find_by(customer_id: 2)
        expect(loyalty_stat.total_spent_cents).to eq(1000)
      end
    end
  end
end
