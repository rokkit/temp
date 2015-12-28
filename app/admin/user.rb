# encoding: UTF-8
ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :phone_token, :role,
                :name, :city, :employe, :work_company, :hobby, :skills_users_attributes, :country, :freezed,
                :party_count, :lounge_id, :confirmed_at, :quote, :avatar

  scope :clients, default: true
  scope :hookmasters

  member_action :freeze, method: :get do
    resource.update_attribute :freezed, true
    redirect_to resource_path, notice: "Freezed!"
  end

  action_item :view, only: :show do
  link_to 'Заморозить', freeze_admin_user_path(user)
end

  index do
    selectable_column
    id_column
    column :phone
    column :name
    column :current_sign_in_at
    column :created_at
    column :role
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  show do

    attributes_table do
      row :name
      row :phone
      row :avatar do
        image_tag user.avatar_url, width: '200px'
      end
      row :birthdate
      row :experience
      row :level
      row :experience
      row :skill_point
      row :role
      row :country
      row :created_at
      row :freezed
      row :party_count
      row :lounge
      row :description
      row :quote

      panel "Навыки" do
         table_for SkillsUsers.where(user_id: user.id).joins(:skill) do
           column 'Название' do |skill|
             skill.skill.name
           end
           column 'Использован' do |skill|
             skill.used_at
           end
           column 'Следующее использование' do |skill|
             skill.cooldown_end_at
           end
         end
      end
      panel "Достижения" do
         table_for user.achievements do
           column 'Название' do |achievement|
             achievement.name
           end
         end
      end if user.role != 'hookmaster'
      panel "Штрафы" do
         table_for user.penalties do
           column 'Название' do |penalty|
             penalty.name
           end
         end
      end if user.role == 'hookmaster'
      panel "Бонусы" do
         table_for user.bonus_user do
           column 'Название' do |bu|
             bu.bonus.name
           end
         end
      end if user.role == 'hookmaster'
    end
    panel 'Данные 1C' do
      payments_ext = user.get_payments_from_ext()
      attributes_table_for user do

        row :idrref do
          if user.idrref
            '0x' + user.idrref
          end
        end
        row 'Потратил всего' do
          payments_ext.map { |p| p['_Fld1574'] }.reduce(0) { |a, sum| sum += a }.to_f
        end
      end
      panel "Покупки" do
         table_for payments_ext do
           column 'Склад' do |p|
             Lounge.get_from_ext(p['_Fld1570RRef'])['_Description']
           end
           column 'Сумма' do |p|
             "#{p['_Fld1575']}р."
           end
         end
      end
    end if user.is_client?
    panel 'Данные кальянщика 1C' do
      attributes_table_for user do
        row :idrref do
          if user.idrref
            '0x' + user.idrref
          end
        end
        row :name do
          user.get_hookmaster_ext.try :_Description
        end

      end
        works_ext = user.get_hookmaster_ext.try(:works_ext) || []
        table_for works_ext do
          column 'Дата' do |p|
              p._Period.strftime('%d.%m.%Y %R')
          end
          column 'Тип' do |p|
              p.action_type
          end
        end
    end if user.is_hookmaster?

  end

  form do |f|
    f.inputs 'User' do
      f.input :phone
      f.input :name
      f.input :avatar
      f.input :birthdate, :start_year => Date.today.year - 18, :end_year => Date.today.year - 80
      f.input :password
      f.input :phone_token
      f.input :role, :as => :select, :collection => [['Клиент',:user], ['Постоянник', :vip], ['Кальянщик', :hookmaster], ['Франчайзер', :franchiser]]
      f.input :country, as: :string
      f.input :freezed
      f.input :skill_point
      f.input :party_count
      f.input :lounge, collection: LoungePolicy::Scope.new(current_user, Lounge).resolve.all.map {|l| [l.title, l.id] }
      f.input :confirmed_at, :input_html => { :value => Time.zone.now }
      f.input :description
      f.input :quote
      f.input :hook_idrref, as: :select, collection: HookmasterExt.all.map {|hm| [hm._Description.to_s.force_encoding("UTF-8"), User.binary_to_string(hm._IDRRef)] }
      f.inputs do
        f.has_many :skills_users, heading: 'Навыки', new_record: "Добавить навык" do |a|
          a.input :skill
          a.input :used_at
          a.input :cooldown_end_at#, :as => :string, :input_html => {:class => "hasDatetimePicker"}
          a.input :_destroy, :as => :boolean
        end
      end
      #
      f.inputs do
        f.has_many :achievements_user, heading: 'Достижения', new_record: "Добавить достижение" do |a|
          a.input :achievement
          a.input :_destroy, :as => :boolean
        end
      end
      f.inputs do
        f.has_many :penalties_user, heading: 'Штрафы', new_record: "Добавить штраф" do |a|
          a.input :penalty
          a.input :_destroy, :as => :boolean
        end
      end
      f.inputs do
        f.has_many :bonus_user, heading: 'Бонусы', new_record: "Добавить бонус" do |a|
          a.input :bonus
          a.input :_destroy, :as => :boolean
        end
      end
    end
    f.actions
  end

  controller do
    def permitted_params
      if params[:user] && params[:user][:role] == 'admin' && !current_user.is_admin?
        params[:user][:role] = 'client'
      end

      params.permit!
    end
    def update
      if permitted_params[:user][:password].blank? && permitted_params[:user][:password_confirmation].blank?
        permitted_params[:user].delete("password")
        permitted_params[:user].delete("password_confirmation")
      end
      if permitted_params[:user][:role] == 'hookmaster'
        permitted_params[:user][:idrref] = params[:user][:hook_idrref]
      end
      permitted_params[:user].delete("hook_idrref")
      @user = User.find(params[:id])

      if @user.update_attributes permitted_params[:user]
        redirect_to admin_user_path(@user), notice: 'Профиль успешно сохранен'
      end
    end
  end
  batch_action :destroy do |ids|
    User.find(ids).each do |u|
      u.destroy
    end
    redirect_to collection_path, alert: "Пользователи успешно удалены"
  end
end
