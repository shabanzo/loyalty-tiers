# frozen_string_literal: true

module LoyaltyStats
  class AnnualGenerator
    def call
      LoyaltyStat.in_batches.each do |relation|
        # 'Update to Bronze'
        relation.where(total_spent_cents: 0).update_all(tier_id: 1)

        # 'Update to Gold'
        relation.where(
          'total_spent_cents >= ?', gold.min_spent_cents
        ).update_all(tier_id: gold.id, total_spent_cents: 0)

        # 'Update to Silver'
        relation.where(
          'total_spent_cents >= ?', silver.min_spent_cents
        ).update_all(tier_id: silver.id, total_spent_cents: 0)
      end
    end

    private

    def gold
      @gold ||= Tier.find(3)
    end

    def silver
      @silver ||= Tier.find(2)
    end
  end
end
