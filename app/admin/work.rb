ActiveAdmin.register Work do
  menu parent: 'Администрирование'
  permit_params :user_id, :work_at, :lounge_id

  index do
    selectable_column
    id_column
    column :user
    column :work_at
    column :lounge
    actions
  end
  form do |f|
    f.inputs 'User' do
        f.input :user, :collection => User.where(role: 3).map{|u| ["#{u.name || ('+'+u.phone)}", u.id]}
        f.input :work_at
        f.input :lounge
    end
    f.actions
  end
end
