class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.string :transaction_type, null: false
      t.decimal :balance_before, precision: 15, scale: 2, null: false
      t.decimal :balance_after, precision: 15, scale: 2, null: false

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
