class AddScoreToMedia < ActiveRecord::Migration[6.0]
  def change
    add_column :media, :zscore, :float, { precision: 6, scale: 4 }
  end
end
