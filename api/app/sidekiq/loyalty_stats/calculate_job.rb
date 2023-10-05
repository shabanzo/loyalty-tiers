# frozen_string_literal: true

class LoyaltyStats::CalculateJob
  include Sidekiq::Job

  def perform(customer_id, total_in_cents)
    loyalty_tier = ::LoyaltyStat.find_or_create_by(customer_id: customer_id)
    loyalty_tier.with_lock do
      loyalty_tier.total_spent_cents += total_in_cents
      loyalty_tier.save
    end
  end
end
