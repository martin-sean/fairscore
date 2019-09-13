class CreateMedia < ActiveRecord::Migration[6.0]
  def change
    create_table :media do |t|
      t.string :title, null: false
      t.integer :year
      t.string :info

      t.timestamps
    end
  end
end
