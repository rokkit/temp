ActiveAdmin.register Payment do
  menu parent: 'Администрирование'
  permit_params :user_id, :amount, :table_id, :visit_date

  index do
    selectable_column
    id_column
    column :user
    column :amount
    column :table
    actions
  end
  form do |f|
    f.inputs 'User' do
        f.input :user, :collection => User.all.map{|u| ["#{u.name || ('+'+u.phone)}", u.id]}
        f.input :amount
        f.input :table
    end
    f.actions
  end
end
