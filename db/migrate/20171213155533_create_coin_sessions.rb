class CreateCoinSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :coin_sessions do |t|
      t.references :trade_process, foreign_key: true, index: true
      t.references :coin, foreign_key: true, index: true
      t.date :end_date
      t.integer :amount_in_crypto
      t.references :previous_coin
      t.references :next_coin

      t.timestamps
    end
  end
end
