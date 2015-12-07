ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :phone_token, :role, :name

  index do
    selectable_column
    id_column
    column :phone
    column :name
    column :current_sign_in_at
    column :created_at
    column :role
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  show do
    attributes_table do
      row :name
      row :phone
      row :experience
      row :level
      row :role
      row :created_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'User' do
      f.input :email
      f.input :phone
      f.input :name
      f.input :password
      f.input :phone_token
      f.input :auth_token
      f.input :role, :as => :select, :collection => [:user, :admin, :vip, :hookmaster]
    end
    f.actions
  end
end
