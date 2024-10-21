require "ostruct"

module Api
  class TransactionsController < ApplicationController
    before_action :authenticate_user!, only: [ :transfer, :index ]

    before_action :validate_users, only: :transfer
    before_action :set_users, only: :transfer

    def transfer
      # handle idempotent requests
      idempotent_key = request.headers["Idempotent-Key"]

      unless valid_idempotent_key?(idempotent_key)
        return render json: { error: "Invalid Idempotent-Key" }, status: :unprocessable_entity
      end

      # create a unique idempotent key for the user
      user_id = session[:user_id]
      key = "idempotent:#{user_id}:#{idempotent_key}"

      response = $redis.get(key)

      # always return same response for the same idempotent key regardless of the request
      return render json: JSON.parse(response), status: :ok if response

      amount = params[:amount].to_f

      # trasfer the money between the users
      result = TransactionService.transfer(@debit_user, @credit_user, amount)
      if result.success
        # store the response in redis for 5 minutes only if the transaction was successful
        $redis.set(key, { transaction: result.transaction }.to_json, ex: 5.minutes)
        render json: { transaction: result.transaction }, status: :ok
      else
        render json: { error: result.error }, status: :unprocessable_entity
      end
    end

    def index
      user = User.find(session[:user_id])
      transactions = user.transactions.order(created_at: :desc)

      transactions = transactions.page(default_page).per(default_per_page)

      render json: { transactions: transactions, meta: pagination_meta(transactions) }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    end

    private

    def validate_users
      if session[:user_id] == params[:credit_user_id]
        render json: { error: "Sender and receiver cannot be the same" }, status: :unprocessable_entity
      end
    end

    def set_users
      @debit_user = User.find(session[:user_id])
      @credit_user = User.find(params[:credit_user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    end

    def valid_idempotent_key?(key)
      key.is_a?(String) && key.length > 0 && key.length <= 36
    end

    def pagination_meta(transactions)
      {
        current_page: transactions.current_page,
        next_page: transactions.next_page,
        prev_page: transactions.prev_page,
        total_pages: transactions.total_pages,
        total_count: transactions.total_count
      }
    end
  end
end
