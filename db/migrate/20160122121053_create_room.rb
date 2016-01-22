class CreateRoom < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.string :password_digest
      t.string :token
      t.integer :access, null: false, default: 0

      t.timestamps
    end
  end
end
