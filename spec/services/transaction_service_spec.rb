require 'rails_helper'

RSpec.describe TransactionService, type: :service do
  let(:debit_user) { create(:user) }
  let(:credit_user) { create(:user) }

  before do
    debit_user.wallet.update(balance: 1000)
    credit_user.wallet.update(balance: 500)
  end

  context 'successful transfer' do
    it 'transfers the correct amount and updates both users wallets' do
      result = TransactionService.transfer(debit_user, credit_user, 200)
      debit_user.reload
      credit_user.reload

      expect(result.success).to eq(true)
      expect(debit_user.wallet.balance).to eq(800) # 1000 - 200
      expect(credit_user.wallet.balance).to eq(700) # 500 + 200
    end

    it 'creates debit and credit transactions' do
      expect {
        TransactionService.transfer(debit_user, credit_user, 200)
      }.to change { Transaction.count }.by(2) # one for debit and one for credit

      debit_transaction = Transaction.find_by(user: debit_user)
      credit_transaction = Transaction.find_by(user: credit_user)

      expect(debit_transaction.transaction_type).to eq('debit')
      expect(credit_transaction.transaction_type).to eq('credit')
    end
  end

  context 'insufficient funds' do
    it 'returns an error when the debit user has insufficient balance' do
      result = TransactionService.transfer(debit_user, credit_user, 2000)

      expect(result.success).to eq(false)
      expect(result.error).to eq('Insufficient funds')
      expect(debit_user.wallet.balance).to eq(1000) # unchanged
      expect(credit_user.wallet.balance).to eq(500) # unchanged
    end
  end

  context 'invalid transfer amount' do
    it 'returns an error when the transfer amount is zero' do
      result = TransactionService.transfer(debit_user, credit_user, 0)

      expect(result.success).to eq(false)
      expect(result.error).to eq('Amount must be greater than zero')
    end

    it 'returns an error when the transfer amount is negative' do
      result = TransactionService.transfer(debit_user, credit_user, -100)

      expect(result.success).to eq(false)
      expect(result.error).to eq('Amount must be greater than zero')
    end
  end

  context 'when saving fails' do
    it 'returns a validation error if a transaction cannot be saved' do
      allow_any_instance_of(Wallet).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(Wallet.new))

      result = TransactionService.transfer(debit_user, credit_user, 200)

      expect(result.success).to eq(false)
      expect(result.error).to match(/Validation failed/)
    end
  end

  context 'unexpected errors' do
    it 'handles unexpected errors gracefully' do
      allow_any_instance_of(Wallet).to receive(:save!).and_raise(StandardError)

      result = TransactionService.transfer(debit_user, credit_user, 200)

      expect(result.success).to eq(false)
      expect(result.error).to eq('An error occurred while processing the transaction')
    end
  end
end
