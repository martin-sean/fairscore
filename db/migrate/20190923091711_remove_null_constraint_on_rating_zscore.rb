class RemoveNullConstraintOnRatingZscore < ActiveRecord::Migration[6.0]
  def change
    change_column_null :ratings, :zscore, true
  end
end
