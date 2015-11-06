ActiveAdmin.register Reservation do
  permit_params :table_id, :user_id, :visit_date
end
