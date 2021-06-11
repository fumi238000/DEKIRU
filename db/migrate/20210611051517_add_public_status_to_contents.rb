class AddPublicStatusToContents < ActiveRecord::Migration[6.0]
  def change
    add_column :contents, :public_status, :integer, default: 0
  end
end
