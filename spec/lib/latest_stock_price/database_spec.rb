require 'rails_helper'

RSpec.describe LatestStockPrice::Database, type: :lib do
  let(:stock_data) { { 'Symbol' => 'ASII', 'Name' => 'Astra', 'LTP' => 5000.0 } }

  describe '.create_or_update_equities' do
    context 'when the stock already exists' do
      let!(:existing_stock) { create(:stock_price, ticker_symbol: 'ASII', company_name: 'Astra', latest_price: 4500.0) }

      it 'updates the existing stock with new attributes' do
        expect {
          described_class.create_or_update_equities(stock_data)
        }.to change { existing_stock.reload.latest_price }.from(4500.0).to(5000.0)
      end
    end

    context 'when the stock does not exist' do
      it 'creates a new stock with the given attributes' do
        expect {
          described_class.create_or_update_equities(stock_data)
        }.to change(StockPrice, :count).by(1)

        stock = StockPrice.find_by(ticker_symbol: 'ASII')
        expect(stock.company_name).to eq('Astra')
        expect(stock.latest_price).to eq(5000.0)
      end
    end

    context 'when the stock is invalid' do
      let(:invalid_stock_data) { { 'Symbol' => '', 'Name' => '', 'LTP' => 1000.0 } }

      it 'does not create a new stock or update an existing one' do
        expect {
          described_class.create_or_update_equities(invalid_stock_data)
        }.not_to change(StockPrice, :count)
      end
    end
  end
end
