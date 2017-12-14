class CreateRestAmounts < ActiveRecord::Migration[5.1]
  def change
    create_table :rest_amounts do |t|
      t.references :trade_process, foreign_key: true
      t.float :amount
      t.integer :amount_of_transactions

      t.timestamps
    end
  end
end
