ActiveAdmin.register Lounge do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :city_id, :title, :blazon, :color

  form(html: { multipart: true }) do |f|
    f.inputs 'Заведения' do
      f.input :title
      f.input :color, as: :string
      f.input :city
      f.input :blazon, as: :file
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
end
