# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::LoyaltyStatsController do
  describe 'GET #show' do
    context 'when loyalty stat exists' do
      let(:loyalty_stat) { create(:loyalty_stat) }

      it 'returns a JSON representation of the loyalty stat' do
        get :show, params: { customer_id: loyalty_stat.customer_id }, format: :json
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(loyalty_stat.id)
        expect(json_response['customer_id']).to eq(loyalty_stat.customer_id)
        expect(json_response['start_date']).to eq(Date.new(Date.current.year, 1, 1).strftime('%Y-%m-%d'))
        expect(json_response['downgrade_date']).to eq(Date.new(Date.current.year, 12, 31).strftime('%Y-%m-%d'))
        expect(json_response['current_tier_name']).to eq(loyalty_stat.tier.name)
      end
    end

    context 'with tier = bronze and total_spent_cents = 0' do
      let(:loyalty_stat) { create(:loyalty_stat, tier_id: 1, total_spent_cents: 0) }

      it 'returns correct calculations' do
        get :show, params: { customer_id: loyalty_stat.customer_id }, format: :json
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['downgrade_to']).to be_nil
        expect(json_response['remaining_amount_to_retain']).to eq(0)
        expect(json_response['remaining_amount_to_upgrade']).to eq(10_000)
        expect(json_response['upgrade_to']).to eq('Silver')
      end
    end

    context 'with tier = bronze and total_spent_cents = 10_000' do
      let(:loyalty_stat) { create(:loyalty_stat, tier_id: 1, total_spent_cents: 10_000) }

      it 'returns correct calculations' do
        get :show, params: { customer_id: loyalty_stat.customer_id }, format: :json
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['downgrade_to']).to be_nil
        expect(json_response['remaining_amount_to_retain']).to eq(0)
        expect(json_response['remaining_amount_to_upgrade']).to eq(40_000)
        expect(json_response['upgrade_to']).to eq('Gold')
      end
    end

    context 'with tier = bronze and total_spent_cents = 50_000' do
      let(:loyalty_stat) { create(:loyalty_stat, tier_id: 1, total_spent_cents: 50_000) }

      it 'returns correct calculations' do
        get :show, params: { customer_id: loyalty_stat.customer_id }, format: :json
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['downgrade_to']).to be_nil
        expect(json_response['remaining_amount_to_retain']).to eq(0)
        expect(json_response['remaining_amount_to_upgrade']).to eq(0)
        expect(json_response['upgrade_to']).to be_nil
      end
    end

    context 'with tier = silver and total_spent_cents = 0' do
      let(:loyalty_stat) { create(:loyalty_stat, tier_id: 2, total_spent_cents: 0) }

      it 'returns correct calculations' do
        get :show, params: { customer_id: loyalty_stat.customer_id }, format: :json
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['downgrade_to']).to eq('Bronze')
        expect(json_response['remaining_amount_to_retain']).to eq(10_000)
        expect(json_response['remaining_amount_to_upgrade']).to eq(10_000)
        expect(json_response['upgrade_to']).to eq('Silver')
      end
    end

    context 'with tier = silver and total_spent_cents = 10_000' do
      let(:loyalty_stat) { create(:loyalty_stat, tier_id: 2, total_spent_cents: 10_000) }

      it 'returns correct calculations' do
        get :show, params: { customer_id: loyalty_stat.customer_id }, format: :json
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['downgrade_to']).to be_nil
        expect(json_response['remaining_amount_to_retain']).to eq(0)
        expect(json_response['remaining_amount_to_upgrade']).to eq(40_000)
        expect(json_response['upgrade_to']).to eq('Gold')
      end
    end

    context 'with tier = silver and total_spent_cents = 50_000' do
      let(:loyalty_stat) { create(:loyalty_stat, tier_id: 2, total_spent_cents: 50_000) }

      it 'returns correct calculations' do
        get :show, params: { customer_id: loyalty_stat.customer_id }, format: :json
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['downgrade_to']).to be_nil
        expect(json_response['remaining_amount_to_retain']).to eq(0)
        expect(json_response['remaining_amount_to_upgrade']).to eq(0)
        expect(json_response['upgrade_to']).to be_nil
      end
    end

    context 'with tier = gold and total_spent_cents = 0' do
      let(:loyalty_stat) { create(:loyalty_stat, tier_id: 3, total_spent_cents: 0) }

      it 'returns correct calculations' do
        get :show, params: { customer_id: loyalty_stat.customer_id }, format: :json
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['downgrade_to']).to eq('Bronze')
        expect(json_response['remaining_amount_to_retain']).to eq(50_000)
        expect(json_response['remaining_amount_to_upgrade']).to eq(10_000)
        expect(json_response['upgrade_to']).to eq('Silver')
      end
    end

    context 'with tier = gold and total_spent_cents = 10_000' do
      let(:loyalty_stat) { create(:loyalty_stat, tier_id: 3, total_spent_cents: 10_000) }

      it 'returns correct calculations' do
        get :show, params: { customer_id: loyalty_stat.customer_id }, format: :json
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['downgrade_to']).to eq('Silver')
        expect(json_response['remaining_amount_to_retain']).to eq(40_000)
        expect(json_response['remaining_amount_to_upgrade']).to eq(40_000)
        expect(json_response['upgrade_to']).to eq('Gold')
      end
    end

    context 'with tier = gold and total_spent_cents = 50_000' do
      let(:loyalty_stat) { create(:loyalty_stat, tier_id: 3, total_spent_cents: 50_000) }

      it 'returns correct calculations' do
        get :show, params: { customer_id: loyalty_stat.customer_id }, format: :json
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['downgrade_to']).to be_nil
        expect(json_response['remaining_amount_to_retain']).to eq(0)
        expect(json_response['remaining_amount_to_upgrade']).to eq(0)
        expect(json_response['upgrade_to']).to be_nil
      end
    end

    context 'when loyalty stat does not exist' do
      it 'returns a not found status' do
        get :show, params: { customer_id: 'nonexistent_id' }, format: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
