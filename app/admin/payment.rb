ActiveAdmin.register Payment do
  permit_params :user_id, :amount, :table_id

  index do
    selectable_column
    id_column
    column :user
    column :visit_date
    column :end_visit_date
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
