# frozen_string_literal: true

class Api::V1::LoyaltyStatsController < ApplicationController
  def show
    loyalty_stat = LoyaltyStat.includes(:tier).find_by(customer_id: params[:customer_id])

    if loyalty_stat
      render json: loyalty_stat, serializer: LoyaltyStatSerializer
    else
      render status: :not_found
    end
  end
end
