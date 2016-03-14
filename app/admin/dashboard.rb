ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do

    # Here is an example of a simple dashboard with columns and panels.
    # current_user.name
    if (current_user.role == "franchiser")
		res_array = Reservation.joins(:table).where(:"tables.lounge_id" => current_user.lounge_id).order(:id => :desc).limit(15);
	else
		res_array = Reservation.order(:id => :desc).limit(15);
	end

    columns do
      column do
        panel "Бронирования" do
			if res_array.any?
				table_for res_array do
					column("Клиент")   {|order|    order.user.name + " +#{order.user.phone}"   }
					column("Заведение") {|order| link_to("#{order.table.lounge.title}", admin_lounge_path(order.table.lounge)) }
					column("Стол") {|order| link_to("#{order.table.title}", admin_table_path(order.table)) }
					column("Дата визита")   {|order| order.visit_date.strftime('%d.%m.%Y %R')  }
				end
			else
				para "Резерваций нет."
			end
        end
      end

      column do
        panel "Клиенты" do
          table_for User.clients.order('id desc').limit(10).each do |customer|
            column(:id)    {|customer| link_to(customer.id, admin_user_path(customer)) }
            column(:phone)    {|customer| link_to(customer.phone, admin_user_path(customer)) }
            column(:name)    {|customer| link_to(customer.name, admin_user_path(customer)) }
          end
        end
      end
    end
    columns do

      column do
        panel "Диаграмма Ганта" do
          div do
            link_to "Бронирования", pages_schedule_path
          end
        end
      end
     end


    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
