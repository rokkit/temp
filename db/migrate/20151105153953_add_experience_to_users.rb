class AddExperienceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :experience, :decimal, default: 0
  end
end
