class CreateTradeProcesses < ActiveRecord::Migration[5.1]
  def change
    create_table :trade_processes do |t|
      t.date :end_time

      t.timestamps
    end
  end
end
