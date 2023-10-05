# frozen_string_literal: true

class Api::V1::CompletedOrdersController < ApplicationController
  def create
    payload_ins = Orders::PayloadConverter.new(order_params)
    order = CompletedOrder.new(payload_ins.params)

    if order.save
      LoyaltyStats::CalculateJob.perform_async(
        order.customer_id, order.total_in_cents
      )
      render json: order, status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.permit(
      :customerId, :customerName, :orderId, :totalInCents, :date
    )
  end
end
