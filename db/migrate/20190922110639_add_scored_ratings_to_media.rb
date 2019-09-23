class AddScoredRatingsToMedia < ActiveRecord::Migration[6.0]
  def self.up
    add_column :media, :scored_ratings, :integer, null: false, default: 0
  end

  def self.down
    remove_column :media, :scored_ratings
  end
end
