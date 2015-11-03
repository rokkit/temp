class CreateSkillsUsers < ActiveRecord::Migration
  def change
    create_table :skills_users do |t|
      t.references :skill, :user
    end
  end
end
