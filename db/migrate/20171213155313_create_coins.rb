class CreateCoins < ActiveRecord::Migration[5.1]
  def change
    create_table :coins do |t|
      t.string :name
      t.string :symbol
      t.integer :last_known_price_in_euros

      t.timestamps
    end
  end
end
