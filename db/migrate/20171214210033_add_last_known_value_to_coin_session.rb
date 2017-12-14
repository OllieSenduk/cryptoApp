class AddLastKnownValueToCoinSession < ActiveRecord::Migration[5.1]
  def change
    add_column :coin_sessions, :last_known_value, :float
  end
end
