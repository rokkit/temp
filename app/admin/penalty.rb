ActiveAdmin.register Penalty do
menu parent: 'Геймификация'
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :description, :slug, :image

index do
  selectable_column
  column :name
  column :image do |penalty|
    image_tag(penalty.image_url, width: '40px')
  end
  actions
end
show do
  attributes_table do
    row :name
    row :image do
      image_tag penalty.image.url, width: '100px'
    end
    row :description
    row :slug
  end
  active_admin_comments
end


form do |f|
  f.inputs "penalty" do

  f.input :name
  f.input :description
  f.input :image, :as => :file, :hint => f.object.image_url.present? \
    ? image_tag(f.object.image_url, width: '100px')
    : content_tag(:span, "no image yet")
  f.input :image_cache, :as => :hidden
  end
  f.actions
  f.semantic_errors
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
