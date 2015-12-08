ActiveAdmin.register Table do
  menu parent: 'Администрирование'
  permit_params :lounge_id, :title, :seats
end
