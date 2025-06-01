class CreateWallets < ActiveRecord::Migration[8.0]
  def change
    create_table :wallets do |t|
      t.integer :balance
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
