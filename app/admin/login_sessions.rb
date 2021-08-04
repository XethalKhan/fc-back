ActiveAdmin.register LoginSession do

  #Position inside header menu. Put "Sessions" inside drop-down list "User management".
  menu parent: "User management", label: "Sessions"

  #Parameters allowed to be edited by ActiveAdmin
  permit_params :user, :start, :end

  #Filters that can be applied on list view
  filter :user
  filter :token
  filter :start
  filter :end
  filter :created_at
  filter :updated_at

  #Pagination options for list view
  config.sort_order = 'start_desc'
  config.per_page = [10, 25, 50, 100]

  #List view of all records
  index do
    id_column
    column :user
    column :token
    column :start
    column :end
    column "IS ACTIVE" do |ls|
      ls.end.nil? ? (status_tag true) : (status_tag false)
    end
    column :created_at
    column :updated_at
    actions
  end

  #Detail view of a record
  show do
    attributes_table do
      row :user
      row :token
      row :start
      row :end
      row "IS ACTIVE" do |ls|
        ls.end.nil? ? (status_tag true) : (status_tag false)
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

  #Edit view of a record
  form do |f|
    f.semantic_errors # shows errors on :base

    f.inputs do
      f.input :user
      #f.input :token, :input_html => { :disabled => true}
      f.input :start, as: :datetime_select
      f.input :end, as: :datetime_select
    end

    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

end
