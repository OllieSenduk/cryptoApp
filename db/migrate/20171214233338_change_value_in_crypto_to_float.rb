class ChangeValueInCryptoToFloat < ActiveRecord::Migration[5.1]
  def change
    change_column :coin_sessions, :amount_in_crypto, :float
  end
end
