class AddImageToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :image, :string, default: ""
  end
end
