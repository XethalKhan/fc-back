class CreateLoginSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :login_sessions do |t|

      t.string :token
      t.datetime :start
      t.datetime :end

      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
