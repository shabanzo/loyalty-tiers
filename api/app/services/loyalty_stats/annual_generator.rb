# frozen_string_literal: true

module LoyaltyStats
  class AnnualGenerator
    def call
      LoyaltyStat.this_year.in_batches.each do |relation|
        new_stats = []
        # Assign new Bronze LoyaltyStats for next year
        new_stats += assign_bronze_stats(relation)

        # Assign new Silver LoyaltyStats for next year
        new_stats += assign_silver_stats(relation)

        # Assign new Gold LoyaltyStats for next year
        new_stats += assign_gold_stats(relation)

        # Create LoyaltyStats for next year in bulk
        LoyaltyStat.insert_all(new_stats)
      end
    end

    private

    def assign_bronze_stats(relation)
      relation.where(
        'total_spent_cents < ?', silver.min_spent_cents
      ).select(
        "customer_id, 1 AS tier_id, #{next_year} AS year"
      ).as_json(except: :id)
    end

    def assign_silver_stats(relation)
      relation.where(
        'total_spent_cents >= ? AND total_spent_cents < ?',
        silver.min_spent_cents,
        gold.min_spent_cents
      ).select(
        "customer_id, 2 AS tier_id, #{next_year} AS year"
      ).as_json(except: :id)
    end

    def assign_gold_stats(relation)
      relation.where(
        'total_spent_cents >= ?', gold.min_spent_cents
      ).select(
        "customer_id, 3 AS tier_id, #{next_year} AS year"
      ).as_json(except: :id)
    end

    def next_year
      @next_year ||= Date.current.next_year.year
    end

    def gold
      @gold ||= Tier.find(3)
    end

    def silver
      @silver ||= Tier.find(2)
    end
  end
end
