require "httparty"
require "json"

module LatestStockPrice
  autoload :Client, "latest_stock_price/client"
  autoload :Fetcher, "latest_stock_price/fetcher"
  autoload :Database, "latest_stock_price/database"
end
