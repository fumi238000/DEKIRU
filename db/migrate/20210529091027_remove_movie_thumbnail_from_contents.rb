class RemoveMovieThumbnailFromContents < ActiveRecord::Migration[6.0]
  def change
    remove_column :contents, :movie_thumbnail, :string
  end
end
