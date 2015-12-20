class AddWorkHoursToLounges < ActiveRecord::Migration
  def change
    add_column :lounges, :work_hours, :string
  end
end
