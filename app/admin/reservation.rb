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
  member_action :approve, method: :get do
    @reservation = Reservation.find(params[:id])
    @reservation.status = :approve
    @reservation.save(validate: false)
    redirect_to admin_reservations_path, notice: "Бронирование подтверждено"
  end

  member_action :cancel, method: :get do
    @reservation = Reservation.find(params[:id])
    @reservation.status = :deleted
    @reservation.save(validate: false)
    redirect_to admin_reservations_path, notice: "Бронирование отменено"
  end

  # filter :lounge_table_eq, :as => :select,
        #  collection: Lounge.order(:id).map { |l| [l.title, l.id] }

  filter :containing_lounge_table_in,
      as: :select,
      label: 'Ложа',
      collection: Lounge.all

  index do
    selectable_column
    id_column
    column :user
    column :lounge do |order|
      "#{order.table.lounge.title}"
    end
    column :table do |order|
      "№#{order.table.id} #{order.table.title}"
    end
    column :visit_date
    column :end_visit_date
    column do |order|
      if order.status == 'wait'
        'Ожидает подтверждения'
      elsif order.status == 'approve'
        'Подтверждено'
      elsif order.status == 'deleted'
        'Отменено'
      end
    end

    actions defaults: false do |order|
      actions_str = []

      actions_str.push link_to("Отменить", cancel_admin_reservation_path(order)) if order.status == 'wait' || order.status == 'approved'
      actions_str.push link_to("Подтвердить", approve_admin_reservation_path(order)) if order.status == 'wait'
      actions_str.join(' ').html_safe

    end
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
