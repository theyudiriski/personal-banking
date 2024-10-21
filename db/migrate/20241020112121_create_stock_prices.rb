class CreateStockPrices < ActiveRecord::Migration[7.2]
  def change
    create_table :stock_prices do |t|
      t.string :ticker_symbol, null: false
      t.string :company_name, null: false
      t.decimal :latest_price, precision: 15, scale: 2, null: false

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
