require "rails_helper"

RSpec.describe "Contents", type: :feature do
  before do
    @user = create(:user) # ユーザー
    @admin = create(:user, user_type: "admin") # 管理者
    @content = create(:content) # コンテンツ
    @material = create(:material, content_id: @content.id) # 材料
    @make = create(:make, content_id: @content.id) # 作り方
    @do_question = create(:question, user_id: @user.id, content_id: @content.id) # 質問（返信あり)
    @end_question = create(:question, user_id: @user.id, content_id: @content.id) # 質問（返信あり)
    @response = create(:response, question_id: @end_question.id) # 返信
  end

  describe "GET #show" do
    let(:content) { create(:content) }

    context "未ログインユーザーの場合" do
      # 異常値のみ
      it "各リンクが表示されないこと" do
        visit content_show_path(@content.id)
        expect(page).not_to have_link ">>追加", href: new_material_path(params: { content_id: @content.id }) # 材料新規作成
        expect(page).not_to have_link ">>追加", href: new_make_path(params: { content_id: @content.id }) # 作り方新規作成
        expect(page).not_to have_link ">>編集", href: edit_material_path(@material.id, params: { content_id: @material.content.id })
        expect(page).not_to have_link ">>削除", href: material_path(@material.id)
        expect(page).not_to have_link ">>編集", href: edit_make_path(@make.id, params: { content_id: @make.content.id })
        expect(page).not_to have_link ">>削除", href: make_path(@make.id)
        expect(page).not_to have_link ">>レビューする", href: new_review_path(params: { content_id: @content.id })
        expect(page).not_to have_link ">>削除", href: question_path(@do_question)
        expect(page).not_to have_link ">>削除", href: question_path(@end_question)
        expect(page).not_to have_link "返信する", href: new_response_path(question_id: @do_question.id)
        expect(page).not_to have_link ">>編集", href: edit_response_path(@end_question.response, question_id: @end_question.id)
        expect(page).not_to have_link ">>削除", href: response_path(@end_question.response)
      end
    end

    context "ユーザーが一般ユーザーの場合" do
      # 異常値のみ
      it "各リンクが表示されないこと" do
        sign_in @user
        visit content_show_path(@content.id)
        expect(page).not_to have_link ">>追加", href: new_material_path(params: { content_id: @content.id }) # 材料新規作成
        expect(page).not_to have_link ">>追加", href: new_make_path(params: { content_id: @content.id }) # 作り方新規作成
        expect(page).not_to have_link ">>編集", href: edit_material_path(@material.id, params: { content_id: @material.content.id })
        expect(page).not_to have_link ">>削除", href: material_path(@material.id)
        expect(page).not_to have_link ">>編集", href: edit_make_path(@make.id, params: { content_id: @make.content.id })
        expect(page).not_to have_link ">>削除", href: make_path(@make.id)
        expect(page).to have_link ">>レビューする", href: new_review_path(params: { content_id: @content.id })
        expect(page).to have_link ">>削除", href: question_path(@do_question)
        expect(page).to have_link ">>削除", href: question_path(@end_question)
        expect(page).not_to have_link ">>返信する", href: new_response_path(question_id: @do_question.id)
        expect(page).not_to have_link ">>編集", href: edit_response_path(@end_question.response, question_id: @end_question.id)
        expect(page).not_to have_link ">>削除", href: response_path(@end_question.response)
      end
    end

    context "管理者の場合" do
      it "新規作成リンクが表示されること" do
        sign_in @admin
        visit content_show_path(@content.id)
        expect(page).to have_link ">>追加", href: new_material_path(params: { content_id: @content.id }) # 材料新規作成
        expect(page).to have_link ">>追加", href: new_make_path(params: { content_id: @content.id }) # 作り方新規作成
      end

      context "材料が存在する時" do
        it "リンクが表示される" do
          sign_in @admin
          visit content_show_path(@content.id)
          expect(page).to have_link ">>編集", href: edit_material_path(@material.id, params: { content_id: @material.content.id })
          expect(page).to have_link ">>削除", href: material_path(@material.id)
        end
      end

      it "作り方が存在する時、リンクが表示される" do
        sign_in @admin
        visit content_show_path(@content.id)
        expect(page).to have_link ">>編集", href: edit_make_path(@make.id, params: { content_id: @make.content.id })
        expect(page).to have_link ">>削除", href: make_path(@make.id)
      end

      it "レビューリンクが表示されないこと" do
        sign_in @admin
        visit content_show_path(@content.id)
        expect(page).not_to have_link ">>レビューする", href: new_review_path(params: { content_id: @content.id })
      end

      it "質問できない状態にあること" do
        sign_in @admin
        visit content_show_path(@content.id)
        expect(page).to have_content "管理者は質問できません。"
        expect(page).not_to have_selector("textarea")
        expect(page).not_to have_button "質問する"
      end

      context "質問が存在する時" do
        it "リンクが表示される" do
          sign_in @admin
          visit content_show_path(@content.id)
          expect(page).to have_link ">>削除", href: question_path(@do_question)
          expect(page).to have_link ">>削除", href: question_path(@end_question)
        end
      end

      context "質問があるが,返信がない場合" do
        it "リンクが表示される" do
          sign_in @admin
          visit content_show_path(@content.id)
          expect(page).to have_link ">>返信する", href: new_response_path(question_id: @do_question.id)
        end
      end

      context "質問があり,返信がある場合" do
        it "リンクが表示される" do
          sign_in @admin
          visit content_show_path(@content.id)
          expect(page).to have_link ">>編集", href: edit_response_path(@end_question.response, question_id: @end_question.id)
          expect(page).to have_link ">>削除", href: response_path(@end_question.response)
        end
      end
    end
  end
end
