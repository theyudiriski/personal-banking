require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  let!(:user) { create(:user, email: 'test@example.com', name: 'Test User') }

  describe 'POST #login' do
    context 'with valid credentials' do
      it 'logs in the user and returns a success message' do
        post :login, params: { email: 'test@example.com' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Login successful', 'user_id' => user.id })
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'with invalid email' do
      it 'returns an error message' do
        post :login, params: { email: 'invalid@example.com' }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Invalid email' })
        expect(session[:user_id]).to be_nil
      end
    end
  end

  describe 'DELETE #logout' do
    before do
      session[:user_id] = user.id
    end

    it 'logs out the user and returns a success message' do
      delete :logout

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ 'message' => 'Logout successful' })
      expect(session[:user_id]).to be_nil
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new user and returns the user object' do
        post :create, params: { user: { name: 'New User', email: 'new@example.com' } }

        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response['user']['name']).to eq('New User')
        expect(json_response['user']['email']).to eq('new@example.com')
      end
    end

    context 'with invalid parameters' do
      it 'returns error messages' do
        post :create, params: { user: { name: '', email: '' } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('errors')
      end
    end
  end
end
