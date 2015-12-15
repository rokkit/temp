class AddStatusToMeets < ActiveRecord::Migration
  def change
    add_column :meets, :status, :integer, default: 0
  end
end
