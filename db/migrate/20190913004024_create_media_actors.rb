class CreateMediaActors < ActiveRecord::Migration[6.0]
  def change
    create_table :media_actors do |t|
      t.references :media, null: false, foreign_key: true
      t.references :actor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
