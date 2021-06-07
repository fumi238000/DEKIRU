class CreateTagMasters < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_masters do |t|
      t.string :tag_name, null: false, unique: true
      t.integer :tag_type

      t.timestamps
    end

    add_index :tag_masters, :tag_name, unique: true
  end
end
