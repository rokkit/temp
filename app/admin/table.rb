ActiveAdmin.register Table do
  menu parent: 'Администрирование'
  permit_params :lounge_id, :title, :seats, :number

  index do
    selectable_column
    id_column
    column :lounge
    column :title
    column :number
    actions
  end

  form do |f|
    f.inputs 'User' do
      f.input :lounge
      f.input :title
      f.input :number, :as => :select, :collection => Table.tables_from_1c(f.object.lounge_id).map {|t| ["#{t[:'Заголовок']} №#{t[:'Номер']}", t[:'Номер']] }
    end
    f.actions
  end

  controller do
    def update
      if params[:table][:number].present?
        tables = Table.tables_from_1c(params[:id])
        table = tables.select { |t| t[:'Номер'] == params[:table][:number] }
        if table.present?

          params[:table][:title] = table[0][:'Заголовок']
        end
      end
      super
    end
  end
end
