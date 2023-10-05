# frozen_string_literal: true

module Orders
  class PayloadConverter
    attr_reader :params

    def initialize(payload)
      @params = {
        customer_id:    payload[:customerId],
        order_id:       payload[:orderId],
        total_in_cents: payload[:totalInCents],
        date:           payload[:date]
      }
    end
  end
end
