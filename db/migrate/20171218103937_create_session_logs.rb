class CreateSessionLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :session_logs do |t|
      t.text :change_log
      t.references :coin_session, foreign_key: true

      t.timestamps
    end
  end
end
