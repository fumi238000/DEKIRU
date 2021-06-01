class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false
      t.string :remote_ip, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :contacts, [:remote_ip, :status]
  end
end
