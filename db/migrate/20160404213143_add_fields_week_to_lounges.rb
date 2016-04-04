class AddFieldsWeekToLounges < ActiveRecord::Migration
  def change
  	  add_column :lounges, :open_hour_wd, :integer
  	  add_column :lounges, :open_hour_we, :integer
  end
end
