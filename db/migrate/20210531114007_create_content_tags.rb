class CreateContentTags < ActiveRecord::Migration[6.0]
  def change
    create_table :content_tags do |t|
      t.references :tag, null: false, foreign_key: { to_table: :tag_masters }
      t.references :content, null: false, foreign_key: { to_table: :contents }

      t.timestamps
    end
  end
end
