ActiveAdmin.register Reservation do
  permit_params :table_id, :user_id, :visit_date, :client_count, :duration

  index do
    selectable_column
    id_column
    column :user
    column :table do |order|
      "#{order.table.lounge.title} №#{order.table.id}"
    end
    column :visit_date
    actions
  end

  form do |f|
    f.inputs 'User' do
      f.input :visit_date
      f.input :user
      f.input :table
      f.input :client_count
      f.input :duration
    end
    f.actions
  end
end
