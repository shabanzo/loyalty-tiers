# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoyaltyStat do
  let(:customer) { create(:customer) }
  let(:tier) { create(:tier) }

  it 'is valid with a customer and tier' do
    loyalty_stat = build(:loyalty_stat, customer: customer, tier: tier)
    expect(loyalty_stat).to be_valid
  end

  it 'is invalid without a customer' do
    loyalty_stat = build(:loyalty_stat, customer: nil, tier: tier)
    expect(loyalty_stat).not_to be_valid
    expect(loyalty_stat.errors[:customer]).to include('must exist')
  end

  it 'is invalid without a tier' do
    loyalty_stat = build(:loyalty_stat, customer: customer, tier: nil)
    expect(loyalty_stat).not_to be_valid
    expect(loyalty_stat.errors[:tier]).to include('must exist')
  end

  it 'belongs to a customer' do
    loyalty_stat = create(:loyalty_stat, customer: customer, tier: tier)
    expect(loyalty_stat.customer).to eq(customer)
  end

  it 'belongs to a tier' do
    loyalty_stat = create(:loyalty_stat, customer: customer, tier: tier)
    expect(loyalty_stat.tier).to eq(tier)
  end
end
