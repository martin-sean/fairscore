class AddDefaultValuesToUserSums < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :rating_sum, :integer, default: 0
    change_column :users, :rating_sum_of_squares, :integer, default: 0
  end
end
