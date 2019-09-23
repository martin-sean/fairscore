class AddZscoreToRatings < ActiveRecord::Migration[6.0]
  def change
    add_column :ratings, :zscore, :float, default: 0, null: false
  end
end
