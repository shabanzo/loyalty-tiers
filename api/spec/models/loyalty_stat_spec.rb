# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoyaltyStat do
  let(:tier) { create(:tier) }

  it 'is valid with a customer id and tier' do
    loyalty_stat = build(:loyalty_stat, tier: tier)
    expect(loyalty_stat).to be_valid
  end

  it 'is invalid without a customer id' do
    loyalty_stat = build(:loyalty_stat, customer_id: nil, tier: tier)
    expect(loyalty_stat).not_to be_valid
  end

  it 'is invalid without a tier' do
    loyalty_stat = build(:loyalty_stat, tier: nil)
    expect(loyalty_stat).not_to be_valid
    expect(loyalty_stat.errors[:tier]).to include('must exist')
  end

  it 'belongs to a tier' do
    loyalty_stat = create(:loyalty_stat, tier: tier)
    expect(loyalty_stat.tier).to eq(tier)
  end
end
