ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :phone_token

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs 'User' do
      f.input :email
      f.input :phone
      f.input :password
      f.input :phone_token
      f.input :auth_token
    end
    f.actions
  end
end