# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::CompletedOrdersController do
  describe 'POST #create' do
    before do
      allow(LoyaltyStats::CalculateJob).to receive(:perform_async).and_call_original
    end

    context 'with valid payload' do
      let(:valid_payload) do
        {
          customerId:   123,
          customerName: 'Taro Suzuki',
          orderId:      'T123',
          totalInCents: 3450,
          date:         '2022-03-04T05:29:59.850Z'
        }
      end

      it 'creates a new order' do
        post :create, params: valid_payload, format: :json
        expect(response).to have_http_status(:created)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['customer_id']).to eq(123)
        expect(parsed_response['order_id']).to eq('T123')
      end

      it 'performs LoyaltyStats::CalculateJob' do
        post :create, params: valid_payload, format: :json
        expect(LoyaltyStats::CalculateJob).to have_received(:perform_async).with(123, 3450)
      end
    end

    context 'with invalid payload' do
      let(:invalid_payload) do
        {
          customerId:   nil, # Missing required attribute
          customerName: 'Taro Suzuki',
          orderId:      'T123',
          totalInCents: 3450,
          date:         '2022-03-04T05:29:59.850Z'
        }
      end

      it 'returns unprocessable_entity status' do
        post :create, params: invalid_payload, format: :json
        expect(response).to have_http_status(:unprocessable_entity)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include('customer_id')
      end
    end

    context 'with duplicate data' do
      let(:duplicate_payload) do
        {
          customerId:   123,
          customerName: 'Taro Suzuki',
          orderId:      'T123',
          totalInCents: 3450,
          date:         '2022-03-04T05:29:59.850Z'
        }
      end

      before do
        create(
          :completed_order,
          customer_id: duplicate_payload[:customerId],
          order_id:    duplicate_payload[:orderId]
        )
      end

      it 'returns unprocessable_entity status' do
        post :create, params: duplicate_payload, format: :json
        expect(response).to have_http_status(:unprocessable_entity)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include('order_id')
      end
    end
  end

  describe 'GET #index' do
    let(:customer_id) { 123 }
    let(:completed_orders) do
      create_list(:completed_order, 10, customer_id: customer_id)
    end

    before do
      completed_orders
    end

    it 'paginates results with default order, per_page and page' do
      get :index, params: { customer_id: customer_id, format: :json }

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.length).to eq(10)
      expect(parsed_response.first['id']).to be < parsed_response.last['id']
    end

    it 'paginates results with custom order' do
      get :index, params: { customer_id: customer_id, order: 'total_in_cents DESC', format: :json }

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.first['total_in_cents']).to be > parsed_response.last['total_in_cents']
    end

    it 'paginates results with custom per_page and page' do
      get :index, params: { customer_id: customer_id, per_page: 5, page: 2, format: :json }

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.length).to eq(5)
    end

    it 'returns an empty list if no completed orders are found' do
      get :index, params: { customer_id: 456, format: :json }

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to be_empty
    end
  end
end
