ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Бронирования" do
          table_for Reservation.order(:id => :desc).limit(15) do
            column("Клиент")   {|order|    order.user.name + " +#{order.user.phone}"   }
            column("Стол") {|order| link_to("#{order.table.lounge.title} №#{order.table.id}", admin_table_path(order.table)) }
            column("Дата визита")   {|order| order.visit_date.strftime('%d-%m-%Y %R')  }
          end
        end
      end

      column do
        panel "Клиенты" do
          table_for User.order('id desc').limit(10).each do |customer|
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
