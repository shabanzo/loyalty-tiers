# frozen_string_literal: true

class LoyaltyStat < ApplicationRecord
  belongs_to :tier

  validates :customer_id, presence: true, uniqueness: { scope: :year }

  scope :this_year, -> { where(year: Date.current.year) }
end
