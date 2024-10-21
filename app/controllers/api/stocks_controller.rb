module Api
  class StocksController < ApplicationController
    def index
      stocks = fetch_stocks
  
      if stocks.empty?
        render json: { message: 'No stocks found' }, status: :not_found
      else
        render json: { stocks: stocks, meta: pagination_meta(stocks) }
      end
    end
  
    def show
      stock = StockPrice.find_by(ticker_symbol: params[:symbol])
  
      if stock
        render json: { stock: stock }, status: :ok
      else
        render json: { error: 'Stock not found' }, status: :not_found
      end
    end
  
    private
  
    def fetch_stocks
      stocks = StockPrice.all
  
      if params[:symbol].present?
        symbols = Array(params[:symbol]) 
        stocks = stocks.where(ticker_symbol: symbols)
      end
  
      stocks = stocks.page(default_page).per(default_per_page)
    end
  
    def pagination_meta(stocks)
      {
        current_page: stocks.current_page,
        next_page: stocks.next_page,
        prev_page: stocks.prev_page,
        total_pages: stocks.total_pages,
        total_count: stocks.total_count
      }
    end
  end  
end
