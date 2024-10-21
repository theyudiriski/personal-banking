module LatestStockPrice
  class Database
    def self.create_or_update_equities(stock_data)
      # Find existing stock by its symbol or unique identifier
      stock = StockPrice.find_by(ticker_symbol: stock_data["Symbol"])

      stock_attributes = {
        ticker_symbol: stock_data["Symbol"],
        company_name: stock_data["Name"],
        latest_price: stock_data["LTP"]
      }

      if stock
        stock.assign_attributes(stock_attributes)

        # Save the stock only if it's valid
        stock.save if stock.valid?
      else
        # Create a new stock record if it doesn't exist
        new_stock = StockPrice.new(stock_attributes)

        # Only save if the new stock is valid
        new_stock.save if new_stock.valid?
      end
    end
  end
end
