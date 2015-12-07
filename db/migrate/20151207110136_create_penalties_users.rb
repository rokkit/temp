class CreatePenaltiesUsers < ActiveRecord::Migration
  def change
    create_table :penalties_users do |t|
      t.references :penalty, :user
    end
  end
end
