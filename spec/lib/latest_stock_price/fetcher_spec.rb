require 'rails_helper'

RSpec.describe LatestStockPrice::Fetcher, type: :lib do
  let(:stock_data) { [{ 'Symbol' => 'ASII', 'Name' => 'Astra', 'LTP' => 4500.0 }] }

  before do
    allow(LatestStockPrice::Client).to receive(:equities).and_return(stock_data)
    allow(LatestStockPrice::Database).to receive(:create_or_update_equities)
  end

  describe '.fetch_and_store_all_equities' do
    it 'fetches data from the API and stores it in the database' do
      described_class.fetch_and_store_all_equities

      expect(LatestStockPrice::Client).to have_received(:equities)
      expect(LatestStockPrice::Database).to have_received(:create_or_update_equities).with(stock_data.first)
    end
  end
end
