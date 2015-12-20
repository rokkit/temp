ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :phone_token, :role,
                :name, :city, :employe, :work_company, :hobby, :skills_users_attributes, :country, :freezed,
                :party_count, :lounge_id, :confirmed_at

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
      panel "Навыки" do
         table_for user.skills do
           column 'Название' do |skill|
             skill.name
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
      end
      panel "Штрафы" do
         table_for user.penalties do
           column 'Название' do |penalty|
             penalty.name
           end
         end
      end
      panel "Бонусы" do
         table_for user.bonus_user do
           column 'Название' do |bu|
             bu.bonus.name
           end
         end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'User' do
      f.input :email
      f.input :phone
      f.input :name
      f.input :birthdate, :start_year => Date.today.year - 18, :end_year => Date.today.year - 80
      f.input :password
      f.input :phone_token
      f.input :auth_token
      f.input :role, :as => :select, :collection => [:user, :admin, :vip, :hookmaster]
      f.input :skill_point
      f.input :level
      f.input :country, as: :string
      f.input :experience
      f.input :freezed
      f.input :party_count
      f.input :lounge
      f.input :confirmed_at, :input_html => { :value => Time.zone.now }
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
      params.permit!
    end
    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      super
    end
  end
  batch_action :destroy do |ids|
    User.find(ids).each do |u|
      u.destroy
    end
    redirect_to collection_path, alert: "Пользователи успешно удалены"
  end
end
