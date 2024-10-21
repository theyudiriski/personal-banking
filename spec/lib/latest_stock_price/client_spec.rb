require 'rails_helper'
require 'webmock/rspec'

RSpec.describe LatestStockPrice::Client, type: :lib do
  let(:api_url) { 'https://latest-stock-price.p.rapidapi.com/equities' }
  let(:headers) do
    {
      'X-Rapidapi-Host' => LatestStockPrice::Client::HOST,
      'X-Rapidapi-Key' => ENV['RAPIDAPI_KEY'],
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent' => 'Ruby',
    }
  end
  let(:response_body) { [{ 'Symbol' => 'ASII', 'Name' => 'Astra', 'LTP' => 4500.0 }].to_json }

  before do
    stub_request(:get, api_url)
      .with(headers: headers)
      .to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })
  end

  describe '.equities' do
    it 'fetches the equities data from the API and parses the response' do
      result = described_class.equities

      expect(result).to be_an(Array)
      expect(result.first['Symbol']).to eq('ASII')
    end
  end

  describe '.parse_response' do
    context 'when the response is successful' do
      let(:response) { instance_double(HTTParty::Response, code: 200, body: response_body) }

      it 'parses the JSON response' do
        parsed_response = described_class.parse_response(response)

        expect(parsed_response).to be_an(Array)
        expect(parsed_response.first['Symbol']).to eq('ASII')
      end
    end

    context 'when the response is unsuccessful' do
      let(:response) { instance_double(HTTParty::Response, code: 500, body: 'Internal Server Error') }

      it 'raises a StandardError' do
        expect {
          described_class.parse_response(response)
        }.to raise_error(StandardError, /API request failed with status 500/)
      end
    end
  end
end
