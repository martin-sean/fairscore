class UpdateRatingZscoreDefaults < ActiveRecord::Migration[6.0]
  def change
    change_column :ratings, :zscore, :float, default: 0, null: false
  end
end
