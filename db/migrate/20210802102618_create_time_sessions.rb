class CreateTimeSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :time_sessions do |t|

      t.datetime :start
      t.datetime :end

      #Maybe we do not need timestamps?
      t.timestamps
    end
  end
end
