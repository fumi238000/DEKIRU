class CreateMakes < ActiveRecord::Migration[6.0]
  def change
    create_table :makes do |t|
      t.references :content, null: false, foreign_key: true
      t.string :detail, null: false

      t.timestamps
    end
  end
end
