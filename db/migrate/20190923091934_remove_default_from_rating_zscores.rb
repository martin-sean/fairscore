class RemoveDefaultFromRatingZscores < ActiveRecord::Migration[6.0]
  def change
    change_column_default :ratings, :zscore, nil
  end
end
