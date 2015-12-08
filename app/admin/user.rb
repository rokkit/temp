ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :phone_token, :role,
                :name, :city, :employe, :work_company, :hobby

  scope :clients, default: true
  scope :hookmasters

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
      row :experience
      row :level
      row :skill_point
      row :role
      row :created_at
      panel "Навыки" do
         table_for user.skills do
           column :name
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
      f.input :password
      f.input :phone_token
      f.input :auth_token
      f.input :role, :as => :select, :collection => [:user, :admin, :vip, :hookmaster]

      #
      # f.has_many :achievements, allow_destroy: true, new_record: "Добавить достижение" do |e|
      #     e.input :achievement, as: :select2_multiple
      # end
    end
    f.actions
  end

  controller do
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
