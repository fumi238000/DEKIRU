class AddIndexContent < ActiveRecord::Migration[6.0]
  def change
    add_index :contents, :title
    add_index :contents, :subtitle
    add_index :contents, :recommend_status
    add_index :contents, :public_status
  end
end
