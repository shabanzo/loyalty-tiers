# frozen_string_literal: true

class CompletedOrder < ApplicationRecord
  validates :customer_id, presence: true
end
