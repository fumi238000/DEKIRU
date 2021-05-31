class CreateTagMasters < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_masters do |t|
      t.string :tag_name, null: false
      t.integer :tag_type

      t.timestamps
    end
  end
end
