ActiveAdmin.register Reservation do
  menu parent: 'Администрирование'
  permit_params :table_id, :user_id, :visit_date, :client_count, :duration, :code, :meets_attributes
  controller do
    # def destroy
    #
    #   @reservation = Reservation.find(params[:id])
    #
    #   @reservation.status = :deleted
    #   @reservation.save
    #   redirect_to admin_reservations_path
    # end

    def permitted_params
      params.permit!
    end
  end
  member_action :approve, method: :get do
    @reservation = Reservation.find(params[:id])
    @reservation.status = :approve
    @reservation.save(validate: false)
    SMSService.send @reservation.user.phone, "Ваша бронь на #{@reservation.visit_date.strftime('%H:%M')} #{@reservation.visit_date.strftime('%d.%m.%Y')} принята, ждём вас в \"#{@reservation.table.lounge.title}\""
    redirect_to admin_reservations_path, notice: "Бронирование подтверждено"
  end

  member_action :cancel, method: :get do
    @reservation = Reservation.find(params[:id])
    @reservation.status = :deleted
    SMSService.send @reservation.user.phone, "К сожалению, Ваша бронь на #{@reservation.visit_date.strftime('%H:%M')} #{@reservation.visit_date.strftime('%d.%m.%Y')} отменена"
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

    actions do |order|
      actions_str = []

      actions_str.push link_to("Отменить", cancel_admin_reservation_path(order)) if order.status == 'wait' || order.status == 'approved'
      actions_str.push link_to("Подтвердить", approve_admin_reservation_path(order)) if order.status == 'wait'
      # actions_str.push link_to("Удалить", destroy_admin_reservation_path(order))
      actions_str.join(' ').html_safe

    end
  end



  form do |f|
    f.inputs 'Reservation' do
      f.input :visit_date
      f.input :user, collection: UserPolicy::Scope.new(current_user, User).resolve.clients.map {|l| ["#{l.name} (+#{l.phone})", l.id] }
      f.input :table, collection: TablePolicy::Scope.new(current_user, Table).resolve.all.map {|l| [l.title, l.id] }
      f.input :client_count, as: :select, :collection => [['1-4', '4'], ['5-6', '6']]
      f.input :duration, as: :select, :collection => [['1.5 часа', '1.5'], ['3 часа', '3']]
      f.input :status, as: :select, :collection => [['Ожидается', 'wait'], ['Подтверждено', 'approve'], ['Отменено', 'deleted']]
      f.input :code
    end
    f.inputs do
      f.has_many :meets, heading: 'Встречи', new_record: "Добавить встречу" do |a|
        a.input :user, collection: UserPolicy::Scope.new(current_user, User).resolve.clients.map {|l| ["#{l.name} (+#{l.phone})", l.id] }
        a.input :status, as: :select, :collection => [['Ожидается', 'wait'], ['Подтверждено', 'approved'], ['Отменено', 'deleted']]
        a.input :_destroy, :as => :boolean
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :code
      row :table
      row :user
      row :visit_date
      row :end_visit_date
      row :created_at
      row :client_count
      row :duration
      row :status do |r|
        Reservation.format_status r.status
      end
      panel "Встречи" do
         table_for reservation.meets do
           column 'Клиент' do |meet|
             meet.user.name
           end
           column 'Статус' do |meet|
             Meet.format_status(meet.status)
           end
         end
      end
    end
    panel 'Данные 1C' do
      attributes_table_for reservation do
        row :idrref do
          if reservation.idrref
            '0x' + reservation.idrref
          end
        end
        row :status_ext do
          if reservation.idrref
            reservation.get_status_from_ext()
          end
        end
      end
    end
  end
end
