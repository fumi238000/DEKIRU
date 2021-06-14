class CreateContents < ActiveRecord::Migration[6.0]
  def change
    create_table :contents do |t|
      t.string :title, null: false
      t.string :subtitle, null: false
      t.string :movie_url, null: false
      t.string :comment, null: false
      t.string :point, null: false
      t.integer :recommend_status, default: 0

      t.timestamps
    end
  end
end
