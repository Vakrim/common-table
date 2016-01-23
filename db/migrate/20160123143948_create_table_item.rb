class CreateTableItem < ActiveRecord::Migration[5.0]
  def change
    create_table :table_items do |t|
      t.belongs_to :room
      t.string :image_path
      t.float :pos_x
      t.float :pos_y
      t.float :width
      t.float :height
      t.integer :pos_z
      t.text :other_properties

      t.timestamps
    end
  end
end
