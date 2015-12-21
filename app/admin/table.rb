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
    f.inputs 'Стол' do
      f.input :lounge, collection: LoungePolicy::Scope.new(current_user, Lounge).resolve.all.map {|l| [l.title, l.id] }
      # f.input :title
      f.input :number, :as => :select, :collection => Table.tables_from_1c(f.object.lounge_id).map {|t| ["#{t[:'Заголовок']} №#{t[:'Номер']}", t[:'Номер']] }
    end
    f.actions
  end

  controller do
    def update
      if params[:table][:number].present?

        tables = Table.tables_from_1c(params[:table][:lounge_id])
        table = tables.select { |t| t[:'Номер'] == params[:table][:number] }

        if table.present?
          params[:table][:title] = table[0][:'Заголовок']
          params[:table][:seats] = tables[0][:'_Fld1669']
        end
      end
      super
    end
  end
end
