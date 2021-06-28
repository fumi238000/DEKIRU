class AddEmailAndNameToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :name, :string
    add_column :contacts, :email, :string

    change_column :contacts, :email, :string, null: false
    change_column :contacts, :name, :string, null: false
  end
end
