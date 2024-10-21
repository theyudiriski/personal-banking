module LatestStockPrice
  class Fetcher
    def self.fetch_and_store_all_equities
      # Call the Client to fetch all data
      data = Client.equities

      # Iterate over the data and create or update in the database
      data.each do |stock_data|
        Database.create_or_update_equities(stock_data)
      end
    end
  end
end
