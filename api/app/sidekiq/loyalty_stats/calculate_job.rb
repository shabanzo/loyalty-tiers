# frozen_string_literal: true

class LoyaltyStats::CalculateJob
  include Sidekiq::Job

  def perform(customer_id, total_in_cents)
    current_stats = find_current_stats(customer_id)
    update_current_stats(current_stats, total_in_cents)
  end

  private

  def current_year
    @current_year ||= Date.current.year
  end

  def prev_year
    @prev_year ||= Date.current.prev_year.year
  end

  def find_current_stats(customer_id)
    ::LoyaltyStat.find_or_create_by(
      customer_id: customer_id,
      year:        current_year
    )
  end

  def find_prev_stats(customer_id)
    ::LoyaltyStat.where(
      customer_id: customer_id,
      year:        prev_year
    ).first
  end

  def update_current_stats(current_stats, total_in_cents)
    # Locking mechanism to prevent the collision
    current_stats.with_lock do
      prev_stats = find_prev_stats(current_stats.customer_id)

      current_stats.total_spent_cents += total_in_cents
      upgradable_tier = find_upgradable_tier(current_stats, prev_stats)

      current_stats.tier = upgradable_tier if upgradable_tier.present?
      current_stats.save
    end
  end

  def find_upgradable_tier(current_stats, prev_stats)
    total_spent_cents = current_stats.total_spent_cents + prev_stats&.total_spent_cents.to_i
    Tier.where(
      'min_spent_cents <= ? AND id > ?', total_spent_cents, current_stats.tier_id
    ).order(id: :asc).first
  end
end
