# frozen_string_literal: true

class LoyaltyStat < ApplicationRecord
  belongs_to :tier

  validates :customer_id, presence: true, uniqueness: { scope: :year }
end
