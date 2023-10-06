# frozen_string_literal: true

class LoyaltyStatSerializer < ActiveModel::Serializer
  attributes :id, :customer_id, :total_spent_cents, :current_tier_name, :start_date,
             :downgrade_to, :downgrade_date, :remaining_amount_to_retain,
             :remaining_amount_to_upgrade, :upgrade_to

  def total_spent_cents
    @total_spent_cents ||= object.total_spent_cents + prev_stats_total_spents
  end

  def current_tier_name
    current_tier&.name.presence
  end

  def start_date
    Date.new(Date.current.prev_year.year, 1, 1)
  end

  def downgrade_to
    return nil if retain_the_current_tier?

    downgrade_tier.name
  end

  def downgrade_date
    Date.new(Date.current.year, 12, 31)
  end

  def remaining_amount_to_retain
    return 0 if retain_the_current_tier?

    current_tier.min_spent_cents - object.total_spent_cents
  end

  def remaining_amount_to_upgrade
    next_tier ? next_tier.min_spent_cents - total_spent_cents : 0
  end

  def upgrade_to
    next_tier&.name.presence
  end

  # ==== Below are helpers ====

  def prev_stats
    @prev_stats ||= ::LoyaltyStat.where(
      customer_id: object.customer_id,
      year:        Date.current.prev_year.year
    ).first
  end

  def prev_stats_total_spents
    @prev_stats_total_spents ||= prev_stats ? prev_stats.total_spent_cents : 0
  end

  def next_tier
    @next_tier ||= Tier.where(
      'min_spent_cents > ? AND id > ?',
      total_spent_cents,
      current_tier.id
    ).order(id: :asc).first
  end

  def current_tier
    @current_tier ||= object.tier
  end

  def downgrade_tier
    @downgrade_tier ||= Tier.where('min_spent_cents <= ?', object.total_spent_cents).order(id: :asc).last
  end

  def retain_the_current_tier?
    current_tier.min_spent_cents <= object.total_spent_cents
  end
end
