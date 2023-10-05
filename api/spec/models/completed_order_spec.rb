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
end
