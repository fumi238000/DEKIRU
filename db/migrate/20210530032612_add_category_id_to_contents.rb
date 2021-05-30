class AddCategoryIdToContents < ActiveRecord::Migration[6.0]
  def change
    add_reference :contents, :category, foreign_key: true
  end
end
