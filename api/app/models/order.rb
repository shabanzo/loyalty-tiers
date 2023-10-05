# frozen_string_literal: true

class Order < ApplicationRecord
  validates :customer_id, presence: true
end
