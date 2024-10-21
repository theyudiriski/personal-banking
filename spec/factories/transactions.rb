FactoryBot.define do
  factory :transaction do
    user { association(:user) }
    amount { 100.0 }
    transaction_type { 'debit' }
    balance_before { 1000.0 }
    balance_after { 900.0 }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
