class AddEndWorkAtToWorks < ActiveRecord::Migration
  def change
    add_column :works, :end_work_at, :datetime
  end
end
