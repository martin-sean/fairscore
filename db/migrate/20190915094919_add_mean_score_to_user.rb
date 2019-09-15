class AddMeanScoreToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :meanscore, :float, { precision: 6, scale: 4 }
  end
end
