class AddDefaulttypeOfTagMaster < ActiveRecord::Migration[6.0]
  def change
    change_column :tag_masters, :tag_type, :integer, default: 0
  end
end
