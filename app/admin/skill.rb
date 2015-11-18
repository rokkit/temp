ActiveAdmin.register Skill do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name, :image, :ancestry, :ancestry_id, :description, :cost

  config.filters = false
  sortable tree: true,
           sorting_attribute: :parent_id

  index as: :sortable do
    label :name # item content
    actions
  end

  show do
    attributes_table do
      row :name
      row :image do
        image_tag skill.image.url, width: '100px'
      end
      row :description
      row :cost
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Skill", as: :sortable do
    # f.input :ancestry, :as => :select, :collection => Skill.all.map {|u| [u.name, u.id]}
    f.input :name
    f.input :description
    # f.input :image
    # f.inputs "Иконка", :multipart => true do
      f.input :image, :as => :file, :hint => f.object.image_url.present? \
        ? image_tag(f.object.image_url, width: '100px')
        : content_tag(:span, "no image yet")
      f.input :image_cache, :as => :hidden
    # end
    f.input :cost
    # f.input do
    # label :name # item content
    # actions
    # end
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
