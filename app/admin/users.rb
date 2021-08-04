ActiveAdmin.register User do

  #Position inside header menu. Put inside drop-down list "User management".
  menu parent: "User management"

  #Parameters allowed to be edited by ActiveAdmin
  permit_params :full_name, :email

  #Filters that can be applied on list view
  filter :full_name
  filter :email
  filter :created_at
  filter :updated_at

  #Pagination options for list view
  config.sort_order = 'id_asc'
  config.per_page = [10, 25, 50, 100]

  #Detail view of all records
  show do
    attributes_table do
      row :full_name
      row :email
      row "LOGIN ALLOWED" do |u|
        u.status ? (status_tag true) : (status_tag false)
      end
      row "CURRENT SESSION" do |u|
        s = u.active_session
        s.empty? ? "User is not loged in" : s
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

  # Define action /admin/user/:id/login that only admin can access
  # Use this action to enable/disable user to login
  member_action :login, method: :get do
    resource.status = !resource.status
    resource.save
    msg = resource.status ? "User has been enabled! User can login." : "User has been disabled! User can not login."
    redirect_to resource_path, notice: msg
  end

  # Define batch action that can be performed on multiple records.
  # Perform action on selected records from list view (index)
  batch_action :disable do |ids|
    ids.each do |id|
      obj = User.find(id)
      obj.status = false
      obj.save
    end
    redirect_to collection_path, notice: "Users have been disabled! They can not login."
  end

  # Add action button on detail view (show) for login action
  action_item :login, only: :show do
    title = "Change status"
    if(user.status)
      title = "Disable"
    else
      title = "Enable"
    end
    link_to title, admin_user_path(user) + "/login"
  end

end
