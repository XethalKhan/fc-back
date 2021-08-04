class AddLastActivityToLoginSessions < ActiveRecord::Migration[6.1]
  def change
    add_column :login_sessions, :last_activity, :datetime
  end
end
