class CreateBacktests < ActiveRecord::Migration[5.1]
  def change
    create_table :backtests do |t|
      t.jsonb :payload

      t.timestamps
    end
  end
end
