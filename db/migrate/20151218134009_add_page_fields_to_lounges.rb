class AddPageFieldsToLounges < ActiveRecord::Migration
  def change
    add_column :lounges, :slogan, :string
    add_column :lounges, :slogan_ru, :string
    add_column :lounges, :address, :string
    add_column :lounges, :phone, :string
    add_column :lounges, :description_header, :string
    add_column :lounges, :description_text, :text
    add_column :lounges, :hookmasters_description, :text
    add_column :lounges, :map_district, :string
    add_column :lounges, :map_description, :text
    add_column :lounges, :vk_link, :string
  end
end
