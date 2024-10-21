require 'rails_helper'

module Api
  RSpec.describe Api::WalletsController, type: :controller do
    describe 'GET #show' do
      let(:user) { create(:user) }

      before do
        user.wallet.update(balance: 1000)

        session[:user_id] = user.id
      end

      context 'when the wallet exists' do
        it 'returns the wallet balance' do
          get :show

          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)

          expect(json_response).to include('balance' => user.wallet.balance.to_s)
        end
      end

      context 'when the wallet does not exist' do
        before do
          user.wallet.destroy
        end

        it 'returns a not found message' do
          get :show

          expect(response).to have_http_status(:not_found)
          json_response = JSON.parse(response.body)

          expect(json_response).to include('error' => 'Wallet not found')
        end
      end

      context 'when user is invalid' do
        it 'returns an unauthorized error' do
          session[:user_id] = 'invalid_id'
          
          get :show
    
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
