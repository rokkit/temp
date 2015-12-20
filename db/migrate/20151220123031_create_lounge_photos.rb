class CreateLoungePhotos < ActiveRecord::Migration
  def change
    create_table :lounge_photos do |t|
      t.string :image
      t.references :lounge, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
