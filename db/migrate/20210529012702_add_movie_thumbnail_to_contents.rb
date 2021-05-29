class AddMovieThumbnailToContents < ActiveRecord::Migration[6.0]
  def up
    change_table :contents, bulk: true do |_t|
      add_column :contents, :movie_thumbnail, :string
      change_column :contents, :movie_thumbnail, :string, null: false
    end
  end

  def down
    change_table :contents, bulk: true do |_t|
      remove_column :contents, :movie_thumbnail
    end
  end
end
