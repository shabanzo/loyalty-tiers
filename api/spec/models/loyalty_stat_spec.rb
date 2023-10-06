# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoyaltyStat do
  it 'is valid with a customer id and tier' do
    loyalty_stat = build(:loyalty_stat)
    expect(loyalty_stat.tier).not_to be_nil
    expect(loyalty_stat.customer_id).not_to be_nil
    expect(loyalty_stat).to be_valid
  end

  it 'is invalid without a customer id' do
    loyalty_stat = build(:loyalty_stat, customer_id: nil)
    expect(loyalty_stat).not_to be_valid
    expect(loyalty_stat.errors[:customer_id]).to include('can\'t be blank')
  end

  it 'is invalid without a tier' do
    loyalty_stat = build(:loyalty_stat, tier: nil)
    expect(loyalty_stat).not_to be_valid
    expect(loyalty_stat.errors[:tier]).to include('must exist')
  end

  it 'validates the uniqueness of customer_id with year scope' do
    existing_loyalty_stat = create(:loyalty_stat, year: 2020)
    loyalty_stat = build(:loyalty_stat, customer_id: existing_loyalty_stat.customer_id, year: 2020)

    expect(loyalty_stat).not_to be_valid
    expect(loyalty_stat.errors[:customer_id]).to include('has already been taken')
  end
end
