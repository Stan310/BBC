class CreateBalanceHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :balance_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount
      t.string :reason

      t.timestamps
    end
  end
end
