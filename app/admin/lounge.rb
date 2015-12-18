ActiveAdmin.register Lounge do
  menu parent: 'Ресурсы'
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :city_id, :title, :blazon, :color, :active, :code
  index do
    selectable_column
    id_column
    column :title
    column :active
    actions
  end
  form(html: { multipart: true }) do |f|
    f.inputs 'Заведения' do
      f.input :title
      f.input :slug
      f.input :code
      f.input :color, as: :string
      f.input :city
      f.input :blazon, as: :file
      f.input :active
      f.input :title
      f.input :color
      f.input :slogan
      f.input :slogan_ru
      f.input :address
      f.input :phone
      f.input :description_header
      f.input :description_text
      f.input :hookmasters_description
      f.input :map_district
      f.input :map_description
      f.input :blazon
      f.input :vk_link
    end
    f.actions
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end
  controller do
    def permitted_params
      params.permit!
    end
  end
end
