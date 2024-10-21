module Api
  class WalletsController < ApplicationController
    before_action :authenticate_user!, only: :show

    def show
      user = User.find(session[:user_id])
      wallet = user.wallet

      if wallet
        render json: { balance: wallet.balance }, status: :ok
      else
        render json: { error: 'Wallet not found' }, status: :not_found
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    end
  end
end
