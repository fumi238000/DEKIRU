# ActiveAdmin.register Question do
#   includes :user
#   includes :response

#   # 更新できる項目は各種ステータスのみ
#   permit_params  :response_content

#   index do
#     selectable_column
#     id_column
#     column :question_content
#     column :status
#     actions
#   end

#   show do
#     panel "質問内容" do
#       attributes_table_for question do
#         row :id
#         row :question_content
#        end
#     end

#       if question.response.present?
#         panel "返信内容" do
#          attributes_table_for question.response do
#           attributes_table_for question.response do
#             row :response_content
#           end
#         end
#       end
#     end
#   end

#   # form do |f|
#   #   panel "返信を作成" do
#   #     attributes_table_for question.response do
#   #       row :response_content
#   #     end
#   #   end
#   # end

#   # create_table "questions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
#   #   t.bigint "content_id", null: false
#   #   t.bigint "user_id", null: false
#   #   t.string "question_content", null: false
#   #   t.integer "status", default: 0
#   #   t.datetime "created_at", precision: 6, null: false
#   #   t.datetime "updated_at", precision: 6, null: false
#   #   t.index ["content_id"], name: "index_questions_on_content_id"
#   #   t.index ["user_id"], name: "index_questions_on_user_id"
#   # end

#   # TODO 質問に対して返信が終わった場合、ステータスを更新すること
#   # controller do
#   #   def update
#   #     creator = Creator.find(params[:id])
#   #     before_status = creator.status
#   #     creator_params = params.require(:creator).permit(:status, :select_user)
#   #     if creator.update(creator_params)
#   #       judge_send_mail(creator, before_status)
#   #       redirect_to admin_creator_path(creator), notice: "ステータスを更新しました"
#   #     else
#   #       redirect_to edit_admin_creator_path(creator), alert: "ステータス更新に失敗しました"
#   #     end
#   #   end
# end
