class AddAdditionalFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :city, :string
    add_column :users, :employe, :string
    add_column :users, :work_company, :string
    add_column :users, :hobby, :text
  end
end
