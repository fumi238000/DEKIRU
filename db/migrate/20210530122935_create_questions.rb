class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.references :content, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :question_content, null: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
