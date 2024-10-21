FactoryBot.define do
  factory :wallet do
    user
    balance { 1000 }
  end
end