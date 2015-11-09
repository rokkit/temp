ActiveAdmin.register Skill do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name, :image, :ancestry, :ancestry_id

  sortable tree: true,
           sorting_attribute: :ancestry

  index :as => :sortable do
    label :name # item content
    actions
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
