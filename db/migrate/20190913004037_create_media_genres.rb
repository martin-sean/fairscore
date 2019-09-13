class CreateMediaGenres < ActiveRecord::Migration[6.0]
  def change
    create_table :media_genres do |t|
      t.references :media, null: false, foreign_key: true
      t.references :genre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
