class CreateSkillsLinks < ActiveRecord::Migration
  def change
    create_table :skills_links do |t|
      t.integer :parent_id
      t.integer :child_id
    end
    add_index :skill_hierarchies, [:parent_id, :child_id],
      unique: true,
      name: "skill_links_idx"

    add_index :skill_links_hierarchies, [:child_id],
      name: "skill_child_idx"
  end
end
