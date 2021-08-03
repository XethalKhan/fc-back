ActiveAdmin.register TimeSession do

  permit_params :start, :end

  menu parent: "Session"

  filter :start
  filter :end

  show do
    attributes_table do
      row :id
      row :start
      row :end
      row "IS ACTIVE" do |ts|
        ts.end.nil? ? (status_tag true) : (status_tag false)
      end
    end
    active_admin_comments
  end

  sidebar "Details", only: :show do
    attributes_table do
      row :created_at
      row :updated_at
    end
  end

end
