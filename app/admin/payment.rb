ActiveAdmin.register Payment do
  menu parent: 'Администрирование'
  permit_params :user_id, :amount, :table_id, :visit_date, :payed_at

  index do
    selectable_column
    id_column
    column :user
    column :amount
    column :payed_at
    column :table
    actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :amount
      row :payed_at
      row :table
      row :created_at
    end
  end
  form do |f|
    f.inputs 'Платеж' do
        # f.input :user, :collection => User.clients.map{|u| ["#{u.name || ('+'+u.phone)}", u.id]}
        f.input :user_phone, :as => :autocomplete,
        :url => autocomplete_user_phone_admin_users_path,
        :input_html => {:id_element => '#payment_user_id',
                        'data-auto-focus' => true,
                        value: payment.new_record? && params[:user_id].present? ? User.find_by_id(params[:user_id]).try(:phone) : payment.user_phone}

        f.input :user_id, :as => :hidden, :input_html => {value: payment.new_record? && params[:user_id].present? ? params[:user_id] : payment.user_id}
        f.input :amount
        f.input :payed_at
        f.input :table
        f.input :reservation, as: :select,
        collection: ReservationPolicy::Scope.new(current_user, Reservation)
                    .resolve
                    .passed.where('visit_date >= ?', (Time.zone.now - 1.day).beginning_of_day)
                    .map {|l| ["#{l.to_full_description}", l.id] }
    end
    f.inputs "Справка" do
    "<div id=\"admin_help\">
      Платежи необходимы для учета количества опыта у клиентов.<br>
      Поиск клиента производится по номеру телефона. Формат: 7XXXXXXXXXX<br>
      Если платеж был произведен в связи с бронью, то необходимо указать соотвествующую бронь. <br>
      В списке отображаются подтвержденные брони со вчера по сегодня
    </div>".html_safe
    end
    f.actions
  end
end
