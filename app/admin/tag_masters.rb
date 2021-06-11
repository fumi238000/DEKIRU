ActiveAdmin.register TagMaster do
  permit_params :tag_name

  index do
    selectable_column
    id_column
    # column :tag_type, :tag_type_i18n, sortable: :tag_type
    column :tag_name
    actions
  end

  show do
    panel "タグ情報" do
      attributes_table_for tag_master do
        row :id
        # row :tag_type
        row :tag_name
        row :created_at
        row :updated_at
      end
    end
  end

  form do |f|
    inputs do
      # input :tag_type, as: :select, collection: TagMaster.tag_types_i18n.invert
      input :tag_name
    end
    f.actions
  end
end
