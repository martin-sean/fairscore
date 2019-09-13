class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
      t.string :remember_digest
      t.float :media_score_mean

      t.timestamps
    end
  end
end
