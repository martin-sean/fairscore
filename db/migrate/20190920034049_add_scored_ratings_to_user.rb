class AddScoredRatingsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :scored_ratings, :integer, null: false, default: 0
  end
end
