ActiveAdmin.register Reservation do
  menu parent: 'Администрирование'
  permit_params :table_id, :user_id, :visit_date, :client_count, :duration
  controller do
    def destroy
      @reservation = Reservation.find(params[:id])
      @reservation.status = :deleted
      @reservation.save
      redirect_to admin_reservations_path
    end
  end

  # filter :lounge_table_eq, :as => :select,
        #  collection: Lounge.order(:id).map { |l| [l.title, l.id] }

  index do
    selectable_column
    id_column
    column :user
    column :table do |order|
      "#{order.table.lounge.title} №#{order.table.id}"
    end
    column :visit_date
    column :end_visit_date
    column do |order|
      if order.status == 'active'
        'Активно'
      else
        'Отменено'
      end
    end
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
