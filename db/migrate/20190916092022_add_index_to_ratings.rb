class AddIndexToRatings < ActiveRecord::Migration[6.0]
  def change
    add_index :ratings, [:user_id, :status_id]
  end
end
