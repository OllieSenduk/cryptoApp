class AddCounterCacheToCoin < ActiveRecord::Migration[5.1]
  def change
    add_column :coins, :coin_sessions_count, :integer
  end
end
