# frozen_string_literal: true

class Tier < ApplicationRecord
  has_many :loyalty_stats
end
