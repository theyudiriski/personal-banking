require 'rails_helper'

RSpec.describe Api::StocksController, type: :controller do
  let!(:bbni) { create(:stock_price, ticker_symbol: 'BBNI', company_name: 'BNI', latest_price: 6000) }
  let!(:asii) { create(:stock_price, ticker_symbol: 'ASII', company_name: 'Astra', latest_price: 4500) }

  describe 'GET #index' do
    context 'when stocks are found' do
      before { get :index }

      it 'returns a list of stocks' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response['stocks'].size).to eq(2)
      end

      it 'includes pagination metadata' do
        json_response = JSON.parse(response.body)

        expect(json_response['meta']).to include(
          'current_page' => 1,
          'next_page' => nil,
          'prev_page' => nil,
          'total_pages' => 1,
          'total_count' => 2
        )
      end
    end

    context 'when no stocks are found' do
      before do
        StockPrice.destroy_all
        get :index
      end

      it 'returns a not found status with a message' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include('message' => 'No stocks found')
      end
    end

    context 'when filtering by symbol' do
      before { get :index, params: { symbol: bbni.ticker_symbol } }

      it 'returns the filtered stock' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response['stocks'].size).to eq(1)
        expect(json_response['stocks'].first['ticker_symbol']).to eq(bbni.ticker_symbol)
      end
    end
  end

  describe 'GET #show' do
    context 'when the stock exists' do
      before { get :show, params: { symbol: bbni.ticker_symbol } }

      it 'returns the stock' do
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['stock']['ticker_symbol']).to eq(bbni.ticker_symbol)
      end
    end

    context 'when the stock does not exist' do
      before { get :show, params: { symbol: 'INVALID' } }

      it 'returns a not found status with an error message' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include('error' => 'Stock not found')
      end
    end
  end
end
