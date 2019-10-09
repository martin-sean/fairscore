class DeleteMediaTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :media
  end
end
