class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.decimal :balance, precision: 15, scale: 2, default: 0.0, null: false

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
