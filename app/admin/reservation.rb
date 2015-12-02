ActiveAdmin.register Reservation do
  permit_params :table_id, :user_id, :visit_date, :client_count, :duration

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
