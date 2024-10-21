require 'rails_helper'

RSpec.describe Api::TransactionsController, type: :controller do
  let(:debit_user) { create(:user) }
  let(:credit_user) { create(:user) }
  let(:idempotent_key) { SecureRandom.uuid }
  
  before do
    debit_user.wallet.update(balance: 1000)
    credit_user.wallet.update(balance: 500)

    session[:user_id] = debit_user.id
    request.headers['Idempotent-Key'] = idempotent_key
  end

  describe 'POST #transfer' do
    context 'with valid parameters' do
      it 'transfers the correct amount and returns success message' do
        post :transfer, params: { credit_user_id: credit_user.id, amount: 200 }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('transaction')
        
        debit_user.reload
        credit_user.reload
        expect(debit_user.wallet.balance).to eq(800)
        expect(credit_user.wallet.balance).to eq(700)
      end

      it 'returns the same response for the same idempotent key' do
        # First request
        post :transfer, params: { credit_user_id: credit_user.id, amount: 200 }
        expect(response).to have_http_status(:ok)
        first_response = response.body

        # Simulate a second request with the same idempotent key
        post :transfer, params: { credit_user_id: credit_user.id, amount: 200 }
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(first_response)
      end
    end

    context 'with an invalid idempotent key' do
      it 'returns an error message' do
        request.headers['Idempotent-Key'] = nil

        post :transfer, params: { credit_user_id: credit_user.id, amount: 200 }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Invalid Idempotent-Key' })
      end
    end

    context 'when the sender and receiver are the same' do
      it 'returns an error message' do
        post :transfer, params: { credit_user_id: debit_user.id, amount: 200 }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Sender and receiver cannot be the same' })
      end
    end

    context 'with insufficient funds' do
      it 'returns an error message' do
        post :transfer, params: { credit_user_id: credit_user.id, amount: 2000 }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Insufficient funds' })
      end
    end

    context 'with invalid user id' do
      it 'returns an error message' do
        post :transfer, params: { credit_user_id: 'invalid_id', amount: 200 }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include('error')
      end
    end
  end

  describe 'GET #index' do
    it 'returns a list of transactions for the user' do
      create(:transaction, user: debit_user, amount: 100)

      get :index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(1)
    end

    it 'returns an error if user unauthorized' do
      session[:user_id] = 'invalid_id'
      
      get :index

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
