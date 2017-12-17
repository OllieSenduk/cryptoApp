class AddCoinMarketIdToCoin < ActiveRecord::Migration[5.1]
  def change
    add_column :coins, :coin_market_id, :string
  end
end
