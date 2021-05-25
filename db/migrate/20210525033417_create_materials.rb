class CreateMaterials < ActiveRecord::Migration[6.0]
  def change
    create_table :materials do |t|
      t.references :content, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :amount, null: false
      t.string :unit, null: false

      t.timestamps
    end
  end
end
