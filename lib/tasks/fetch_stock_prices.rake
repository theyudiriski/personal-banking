namespace :latest_stock_prices do
  desc 'Fetch and store the latest stock prices'
  task fetch_and_store: :environment do
    FetchStockPriceWorker.perform_async
    puts 'Stock price fetch and store job enqueued'
  end
end
