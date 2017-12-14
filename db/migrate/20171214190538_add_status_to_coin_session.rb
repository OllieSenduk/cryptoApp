class AddStatusToCoinSession < ActiveRecord::Migration[5.1]
  def change
    add_column :coin_sessions, :status, :string, default: "running"
  end
end
