ActiveAdmin.register Reservation do
  permit_params :table_id, :user_id, :visit_date

  form do |f|
    f.inputs 'User' do
      f.input :visit_date
      f.input :user
      f.input :table
    end
    f.actions
  end
end
