class ChangeUserIdColumnToContacts < ActiveRecord::Migration[6.0]
  def change
    remove_reference :contacts, :user, null: false, foreign_key: true
    add_reference :contacts, :user, null: true, foreign_key: true
  end
end
