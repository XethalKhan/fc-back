ActiveAdmin.register TimeSession do

  #Parameters allowed to be edited by ActiveAdmin
  permit_params :start, :end

  #Filters that can be applied on list view
  filter :start
  filter :end
  filter :created_at
  filter :updated_at

  #Detail view of a record
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

  #Sidebar with metadata, to be displayed on detail view
  sidebar "Meta", only: :show do
    attributes_table do
      row :created_at
      row :updated_at
    end
  end

end
