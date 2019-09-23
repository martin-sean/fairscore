class ChangeMediaZScoreSUm < ActiveRecord::Migration[6.0]
  def change
    change_column :media, :zscore_sum, :float, default: 0, null: false
  end
end
