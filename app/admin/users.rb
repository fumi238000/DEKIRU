ActiveAdmin.register User do
  # 管理画面で削除は行わない
  actions :all, except: [:destroy]

  # 変更できるのはユーザータイプのみ
  permit_params :user_type

  index do
    selectable_column
    id_column
    column :email
    column :user_type, :user_type_i18n, sortable: :user_type
    actions
  end

  form do |f|
    f.inputs do
      f.input :user_type, as: :select, collection: User.user_types_i18n.invert
    end
    f.actions
  end
end
