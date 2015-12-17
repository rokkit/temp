ActiveAdmin.register Payment do
  menu parent: 'Администрирование'
  permit_params :user_id, :amount, :table_id, :visit_date, :payed_at

  index do
    selectable_column
    id_column
    column :user
    column :amount
    column :payed_at
    column :table
    actions
  end
  form do |f|
    f.inputs 'User' do
        f.input :user, :collection => User.clients.map{|u| ["#{u.name || ('+'+u.phone)}", u.id]}
        f.input :amount
        f.input :payed_at
        f.input :table
    end
    f.actions
  end
end
