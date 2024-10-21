require 'httparty'

module LatestStockPrice
  class Client
    BASE_URL = 'https://latest-stock-price.p.rapidapi.com'.freeze
    API_KEY = ENV['RAPIDAPI_KEY'].freeze

    HOST = 'latest-stock-price.p.rapidapi.com'.freeze

    # Method to fetch all equities
    def self.equities
      url = "#{BASE_URL}/equities"
      headers = {
        "x-rapidapi-host" => HOST,
        "x-rapidapi-key" => API_KEY
      }

      # Send GET request to the external API
      response = HTTParty.get(url, headers: headers)
      parse_response(response) # Parse the response
    end

    # Handle the response and return JSON or raise error
    def self.parse_response(response)
      if response.code == 200
        JSON.parse(response.body) # Parse JSON if request was successful
      else
        raise StandardError, "API request failed with status #{response.code}: #{response.body}"
      end
    end
  end
end
