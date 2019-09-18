class UpdateUserScores < ActiveRecord::Migration[6.0]
  def change
    # Remove old columns (why were there two??)
    remove_column :users, :media_score_mean
    remove_column :users, :meanscore

    # New columns for calculating the mean, standard deviation and z score.
    add_column :users, :rating_sum, :integer
    add_column :users, :rating_sum_of_squares, :integer
  end
end
