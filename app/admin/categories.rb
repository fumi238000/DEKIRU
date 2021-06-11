ActiveAdmin.register Category do
  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    column "コンテンツ数" do |category|
      category.contents.count
    end
    column :created_at
    column :updated_at
    actions
  end

  show do |category|
    attributes_table(*category.class.columns.collect {|column| column.name.to_sym })
    panel "コンテンツ一覧" do
      table_for category.contents do
        column :title
        # TODO : youtubeのサムネイル画像を表示させる
        column :publish_date
      end
    end
    active_admin_comments
  end
end
