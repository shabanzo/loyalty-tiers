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

  def index
    completed_orders = CompletedOrder.where(
      'customer_id = ? AND date >= ?',
      params[:customer_id],
      Date.current.last_year.beginning_of_year
    ).order(order).offset((page - 1) * per_page).limit(per_page)
    render json: completed_orders, status: :ok
  end

  private

  def order_params
    params.permit(
      :customerId, :customerName, :orderId, :totalInCents, :date
    )
  end

  def per_page
    params[:per_page] ? params[:per_page].to_i : 10
  end

  def page
    params[:page] ? params[:page].to_i : 1
  end

  def order
    params[:order] || 'id ASC'
  end
end
