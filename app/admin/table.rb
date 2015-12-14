ActiveAdmin.register Table do
  menu parent: 'Администрирование'
  permit_params :lounge_id, :title, :seats

  index do
    selectable_column
    id_column
    column :lounge
    column :title
    column :number
    actions
  end
end
