# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Orders::PayloadConverter do
  describe '#initialize' do
    let(:payload) do
      {
        customerId:   123,
        orderId:      'T123',
        totalInCents: 3450,
        date:         '2022-03-04T05:29:59.850Z'
      }
    end

    it 'converts payload attributes to params' do
      converter = described_class.new(payload)

      expect(converter.params[:customer_id]).to eq(123)
      expect(converter.params[:order_id]).to eq('T123')
      expect(converter.params[:total_in_cents]).to eq(3450)
      expect(converter.params[:date]).to eq('2022-03-04T05:29:59.850Z')
    end
  end
end
