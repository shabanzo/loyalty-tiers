# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompletedOrder do
  it 'is valid with a customer id and tier' do
    completed_order = build(:completed_order)
    expect(completed_order).to be_valid
  end

  it 'is invalid without a customer id' do
    completed_order = build(:completed_order, customer_id: nil)
    expect(completed_order).not_to be_valid
  end

  it 'is invalid with a duplicate order id within the same customer id' do
    customer_id = 1
    order_id = 'T123'

    create(:completed_order, customer_id: customer_id, order_id: order_id)

    completed_order = build(:completed_order, customer_id: customer_id, order_id: order_id)
    expect(completed_order).not_to be_valid
  end

  it 'is valid with the same order id for different customer ids' do
    order_id = 'T123'

    create(:completed_order, customer_id: 1, order_id: order_id)
    create(:completed_order, customer_id: 2, order_id: order_id)

    completed_order = build(:completed_order, customer_id: 3, order_id: order_id)
    expect(completed_order).to be_valid
  end
end
