FactoryBot.define do
  factory :stock_price do
    ticker_symbol { "BBRI" }
    latest_price { 5000.0 }
  end
end
