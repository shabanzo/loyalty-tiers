# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order do
  it 'is valid with a customer id and tier' do
    order = build(:order)
    expect(order).to be_valid
  end

  it 'is invalid without a customer id' do
    order = build(:order, customer_id: nil)
    expect(order).not_to be_valid
  end
end
