class SetUserScoreColumnsNonNullable < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :rating_sum, :integer, null: false
    change_column :users, :rating_sum_of_squares, :integer, null: false
  end
end
