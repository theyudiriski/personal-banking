class StockPrice < ApplicationRecord
  validates :latest_price, presence: true, numericality: { greater_than: 0 }
  validates :ticker_symbol, presence: true
  validates :company_name, presence: true
end
