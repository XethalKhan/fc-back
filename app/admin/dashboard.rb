ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do

    today = Time.new

    total_24h = TimeSession.where(start: (today - 1.day)..today).count
    active_24h = TimeSession.where(start: (today - 1.day)..today, end: nil).count

    # WARNING!!!
    # TIMESTAMPDIFF is MySQL specific function!
    avg = TimeSession.where.not(end: nil).average("TIMESTAMPDIFF(MINUTE, start, end)")

    panel "Time session statistics" do
      columns do
        column do
          h3 "Total sessions created in last 24h"
          h3 "Active sessions created in last 24h"
          h3 "Average duration of time sessions (minutes)"
        end

        column do
          h3 total_24h
          h3 active_24h
          h3 avg
        end
      end
    end

  end # content


end
