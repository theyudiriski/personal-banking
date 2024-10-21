class Transaction < ApplicationRecord
  belongs_to :user

  validates :amount, numericality: { greater_than: 0 }
  validates :transaction_type, inclusion: { in: %w(debit credit) }

  validates :balance_before, :balance_after, presence: true
end
