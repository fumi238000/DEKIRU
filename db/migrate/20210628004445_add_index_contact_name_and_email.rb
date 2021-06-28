class AddIndexContactNameAndEmail < ActiveRecord::Migration[6.0]
  def change
    add_index :contacts, [:name, :email]
  end
end
