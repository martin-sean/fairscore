class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.int :user_id
      t.int :media_id
      t.int :score

      t.timestamps
    end
  end
end
