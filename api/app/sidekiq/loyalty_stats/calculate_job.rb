# frozen_string_literal: true

class LoyaltyStats::CalculateJob
  include Sidekiq::Job

  def perform(order_id)
    @order = CompletedOrder.where(id: order_id).first

    return unless @order

    update_current_stats
  end

  private

  def current_year
    @current_year ||= @order.date.year
  end

  def prev_year
    @prev_year ||= @order.date.prev_year.year
  end

  def this_year_stats
    @this_year_stats ||= ::LoyaltyStat.find_or_create_by(
      customer_id: customer_id,
      year:        current_year
    )
  end

  def prev_year_stats
    @prev_year_stats ||= ::LoyaltyStat.where(
      customer_id: customer_id,
      year:        prev_year
    ).first
  end

  def customer_id
    @customer_id ||= @order.customer_id
  end

  def total_in_cents
    @total_in_cents ||= @order.total_in_cents
  end

  def total_spent_cents
    this_year_stats.total_spent_cents + prev_year_stats&.total_spent_cents.to_i
  end

  def upgradable_tier
    @upgradable_tier ||= Tier.where(
      'min_spent_cents <= ? AND id > ?', total_spent_cents, this_year_stats.tier_id
    ).order(id: :asc).first
  end

  def update_current_stats
    # Locking mechanism to prevent the collision
    this_year_stats.with_lock do
      this_year_stats.total_spent_cents += total_in_cents
      this_year_stats.tier = upgradable_tier if upgradable_tier.present?
      this_year_stats.save
    end
  end
end
