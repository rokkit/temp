ActiveAdmin.register Skill do
  menu parent: 'Геймификация'
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name, :image, :ancestry, :ancestry_id, :description, :cost, :parent_id, :role, :row, :cooldown

  config.filters = false
  # sortable tree: true,
          #  sorting_attribute: :parent_id

  controller do
    # This code is evaluated within the controller class

    def update
      @skill = Skill.find(params[:id])
      need_parent_skills = params[:skill][:parent_skills].delete_if(&:empty?)
      current_skill_links = SkillsLink.where(child_id: @skill.id)

      current_skill_links.each do |skill_link|
        skill_link.destroy if !params[:skill][:parent_skills].include?(skill_link.id)
      end

      need_parent_skills.each do |parent_skill_id|
        link = SkillsLink.where(parent_id: parent_skill_id, child_id: @skill.id).first
        if !link
          link = SkillsLink.create!(parent_id: parent_skill_id, child_id: @skill.id)
        end
      end
      if @skill.update_attributes params[:skill].permit!#(:name, :description, :image_cache, :cost, :row, :role, :image)
        redirect_to admin_skills_path, notice: "Successfully created Skill."
      else
        redirect_to :back
      end
    end
  end
  index do
    column :id
    column :name # item content
    column :cost
    column :row
    column :role
    column :cooldown
    column do |skill|
      skill.parent_skills_obj.map {|s| "##{s.id} #{s.name}" }.join('; ')
    end
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
      row :row
      row :role
      row :cooldown
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Skill" do
    f.input :parent_skills,
            :as => :check_boxes,
            :collection => Skill.where.not(id: f.object.id).map {|s| ["##{s.id} #{s.name}", s.id] },
            :for => :parent_skills
            # :selected_values => [
                    # SkillsLink.where(child_id: f.object.id).pluck(:parent_id)
            # ]#, :input_html => { :checked => SkillsLink.where(child_id: f.object.id) }#, :as => :select, :collection => Skill.all.map {|u| [u.name, u.id]}
    f.input :name
    f.input :description
    f.input :role, :as => :select, :collection => [:user, :hookmaster]
    # f.input :image
    # f.inputs "Иконка", :multipart => true do
      f.input :image, :as => :file, :hint => f.object.image_url.present? \
        ? image_tag(f.object.image_url, width: '100px')
        : content_tag(:span, "no image yet")
      f.input :image_cache, :as => :hidden
    # end
    f.input :cost
    f.input :row
    f.input :cooldown
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
