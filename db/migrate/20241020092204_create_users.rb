class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
