class CreateBonusUsers < ActiveRecord::Migration
  def change
    create_table :bonus_users do |t|
      t.references :bonus, :user
    end

    add_index :bonus_users, [:bonus_id, :user_id],
      name: "bonus_users_index",
      unique: true
  end
end
