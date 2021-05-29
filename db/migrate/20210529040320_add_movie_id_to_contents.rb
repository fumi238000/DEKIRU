class AddMovieIdToContents < ActiveRecord::Migration[6.0]
  def change
    add_column :contents, :movie_id, :string
  end
end
