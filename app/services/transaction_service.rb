class TransactionService
  DEBIT_TYPE = 'debit'.freeze
  CREDIT_TYPE = 'credit'.freeze

  def self.transfer(debit_user, credit_user, amount)
    return TransactionResult.new(success: false, error: 'Amount must be greater than zero') unless amount > 0

    # Wrap inside a transaction to ensure atomicity
    ActiveRecord::Base.transaction do
      from_wallet = debit_user.wallet
      to_wallet = credit_user.wallet

      return TransactionResult.new(success: false, error: 'Insufficient funds') if from_wallet.balance < amount

      # Debit from the sender's wallet
      balance_before_from = from_wallet.balance
      from_wallet.balance -= amount
      balance_after_from = from_wallet.balance

      # Credit to the receiver's wallet
      balance_before_to = to_wallet.balance
      to_wallet.balance += amount
      balance_after_to = to_wallet.balance

      debit_transaction = Transaction.new(
        user: debit_user,
        amount: amount,
        transaction_type: DEBIT_TYPE,
        balance_before: balance_before_from,
        balance_after: balance_after_from
      )

      credit_transaction = Transaction.new(
        user: credit_user,
        amount: amount,
        transaction_type: CREDIT_TYPE,
        balance_before: balance_before_to,
        balance_after: balance_after_to
      )

      from_wallet.save!
      to_wallet.save!
      debit_transaction.save!
      credit_transaction.save!

      TransactionResult.new(success: true, transaction: debit_transaction)
    rescue ActiveRecord::RecordInvalid => e
      # Specific validation error, can provide detailed feedback
      TransactionResult.new(success: false, error: e.message)
    rescue => e
      # Catch-all for other errors, provides a generic message
      TransactionResult.new(success: false, error: 'An error occurred while processing the transaction')
    end
  end
end