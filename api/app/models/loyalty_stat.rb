# frozen_string_literal: true

class LoyaltyStat < ApplicationRecord
  belongs_to :customer
  belongs_to :tier
end
