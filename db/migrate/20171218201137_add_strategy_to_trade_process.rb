class AddStrategyToTradeProcess < ActiveRecord::Migration[5.1]
  def change
    add_column :trade_processes, :strategy, :string
  end
end
