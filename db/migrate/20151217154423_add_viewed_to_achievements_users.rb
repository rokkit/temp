class AddViewedToAchievementsUsers < ActiveRecord::Migration
  def change
    add_column :achievements_users, :viewed, :boolean, default: false
  end
end
