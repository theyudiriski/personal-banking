class User < ApplicationRecord
  has_one :wallet, dependent: :destroy
  has_many :transactions

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true, email: true

  before_validation :downcase_email
  after_create :initialize_wallet

  private

  def initialize_wallet
    create_wallet(balance: 0)
  end

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
