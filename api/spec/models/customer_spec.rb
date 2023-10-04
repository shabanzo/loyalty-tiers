# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer do
  it 'is valid with a name' do
    customer = build(:customer, name: 'John Doe')
    expect(customer).to be_valid
  end

  it 'is invalid without a name' do
    customer = build(:customer, name: nil)
    expect(customer).not_to be_valid
  end

  it 'has many orders' do
    customer = create(:customer)
    order1 = create(:order, customer: customer)
    order2 = create(:order, customer: customer)

    expect(customer.orders).to include(order1, order2)
  end
end
