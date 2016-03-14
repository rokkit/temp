ActiveAdmin.register Work do
  menu parent: 'Администрирование'
  permit_params :user_id, :work_at, :lounge_id, :end_work_at, :amount

  index do
    selectable_column
    id_column
    column :user
    column :work_at
    column :end_work_at
    column :lounge
    column :amount
    actions
  end

  form do |f|
    f.inputs 'Рабочая смена' do
        f.input :user, :collection => User.hookmasters.map{|u| ["#{u.name || ('+'+u.phone)}", u.id]}
        f.input :work_at
        f.input :end_work_at
        f.input :lounge
        f.input :amount
    end
    f.actions
  end
end
