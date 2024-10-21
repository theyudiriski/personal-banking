class FetchStockPriceWorker
  include Sidekiq::Worker

  def perform
    LatestStockPrice::Fetcher.fetch_and_store_all_equities
  end
end
