class RenameMediaZscoreToZscoreSum < ActiveRecord::Migration[6.0]
  def change
    rename_column :media, :zscore, :zscore_sum
  end
end
