class AddIndexQuestion < ActiveRecord::Migration[6.0]
  def change
    add_index :questions, :status
  end
end
