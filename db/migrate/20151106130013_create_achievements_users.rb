class CreateAchievementsUsers < ActiveRecord::Migration
  def change
    create_table :achievements_users do |t|
      t.references :achievement, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
