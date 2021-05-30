class CreateResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :responses do |t|
      t.belongs_to :question, null: false, index: { unique: true }, foreign_key: true
      t.string :response_content, null: false

      t.timestamps
    end
  end
end
