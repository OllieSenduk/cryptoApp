class CreateCoinUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table :coin_updates do |t|
      t.references :coin_session, foreign_key: true, index: true
      t.integer :percent_change_1h
      t.integer :percent_change_24h
      t.integer :percent_change_7d
      t.integer :price_in_euro

      t.timestamps
    end
  end
end
