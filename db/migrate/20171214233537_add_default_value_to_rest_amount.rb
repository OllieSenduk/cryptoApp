class AddDefaultValueToRestAmount < ActiveRecord::Migration[5.1]
  def change
    change_column :rest_amounts, :amount, :float, default: 0
    change_column :rest_amounts, :amount_of_transactions, :integer, default: 0
  end
end
