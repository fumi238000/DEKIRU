class CreateContentTags < ActiveRecord::Migration[6.0]
  def change
    create_table :content_tags do |t|
      t.references :tag, null: false, foreign_key: { to_table: :tag_masters }, index: false
      t.references :content, null: false, foreign_key: { to_table: :contents }, index: false

      t.timestamps
    end
    add_index :content_tags, [:content_id, :tag_id], unique: true
  end
end
