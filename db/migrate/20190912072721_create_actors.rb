class CreateActors < ActiveRecord::Migration[6.0]
  def change
    create_table :actors do |t|
      t.string :name, null: false
      t.integer :age
      t.string :info

      t.timestamps
    end
  end
end
