class AddUniqueIndexToRatings < ActiveRecord::Migration[6.0]
  def change
    add_index :ratings, [:user_id, :media_id], unique: true
  end
end
