# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order do
  it 'belongs to a customer' do
    customer = create(:customer)
    order = create(:order, customer: customer)

    expect(order.customer).to eq(customer)
  end
end
