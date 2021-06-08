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
    # 未ログインユーザー
    context "未ログインユーザーの場合" do
      it "ユーザー専用リンクが表示されないこと" do
        visit content_show_path(@content.id)
        expect(page).not_to have_link ">>レビューする", href: new_review_path(params: { content_id: @content.id })
        # お気に入りリンクが表示されない
      end

      it "管理者専用リンクが表示されないこと" do
        visit content_show_path(@content.id)
        expect(page).not_to have_link ">>追加", href: new_material_path(params: { content_id: @content.id }) # 材料新規作成
        expect(page).not_to have_link ">>追加", href: new_make_path(params: { content_id: @content.id }) # 作り方新規作成
        expect(page).not_to have_link ">>編集", href: edit_material_path(@material.id, params: { content_id: @material.content.id })
        expect(page).not_to have_link ">>削除", href: material_path(@material.id)
        expect(page).not_to have_link ">>編集", href: edit_make_path(@make.id, params: { content_id: @make.content.id })
        expect(page).not_to have_link ">>削除", href: make_path(@make.id)
        expect(page).not_to have_link ">>削除", href: question_path(@end_question)
        expect(page).not_to have_link ">>返信する", href: new_response_path(question_id: @do_question.id)
        expect(page).not_to have_link ">>編集", href: edit_response_path(@end_question.response, question_id: @end_question.id)
        expect(page).not_to have_link ">>削除", href: response_path(@end_question.response)
      end
    end

    # ログインユーザー
    context "ユーザーが一般ユーザーの場合" do
      it "ユーザー専用リンクが表示されること" do
        sign_in @user
        visit content_show_path(@content.id)
        expect(page).to have_link ">>レビューする", href: new_review_path(params: { content_id: @content.id })
        # お気に入りリンクが表示される
      end

      it "管理者専用リンクが表示されないこと" do
        sign_in @user
        visit content_show_path(@content.id)
        expect(page).not_to have_link ">>追加", href: new_material_path(params: { content_id: @content.id }) # 材料新規作成
        expect(page).not_to have_link ">>追加", href: new_make_path(params: { content_id: @content.id }) # 作り方新規作成
        expect(page).not_to have_link ">>編集", href: edit_material_path(@material.id, params: { content_id: @material.content.id })
        expect(page).not_to have_link ">>削除", href: material_path(@material.id)
        expect(page).not_to have_link ">>編集", href: edit_make_path(@make.id, params: { content_id: @make.content.id })
        expect(page).not_to have_link ">>削除", href: make_path(@make.id)
        expect(page).not_to have_link ">>削除", href: question_path(@end_question)
        expect(page).not_to have_link ">>返信する", href: new_response_path(question_id: @do_question.id)
        expect(page).not_to have_link ">>編集", href: edit_response_path(@end_question.response, question_id: @end_question.id)
        expect(page).not_to have_link ">>削除", href: response_path(@end_question.response)
      end
    end

    context "自分の質問に返信がない場合" do
      it "質問削除リンクが表示されること" do
        sign_in @user
        visit content_show_path(@content.id)
        expect(page).to have_link ">>削除", href: question_path(@do_question)
      end
    end

    context "自分の質問に返信がある場合" do
      it "質問削除リンクが表示されないこと" do
        sign_in @user
        visit content_show_path(@content.id)
        expect(page).not_to have_link ">>削除", href: question_path(@end_question)
      end
    end
  end

    # 管理者
  context "管理者の場合" do
    it "ユーザー専用リンクが表示されないこと" do
        # お気に入りボタン
      expect(page).not_to have_link ">>レビューする", href: new_review_path(params: { content_id: @content.id })
    end

    it "管理者専用リンクが表示されること" do
      sign_in @admin
      visit content_show_path(@content.id)
      expect(page).to have_link ">>編集", href: edit_content_path(@content) # コンテンツ編集リンク
      expect(page).to have_link ">>削除", href: content_path(@content) # コンテンツ削除リンク
      expect(page).to have_link ">>追加", href: new_material_path(params: { content_id: @content.id }) # 材料追加
      expect(page).to have_link ">>追加", href: new_make_path(params: { content_id: @content.id }) # 作り方追加
    end

    context "材料が存在する時" do
      it "リンクが表示される" do
        sign_in @admin
        visit content_show_path(@content.id)
        expect(page).to have_link ">>編集", href: edit_material_path(@material.id, params: { content_id: @material.content.id })
        expect(page).to have_link ">>削除", href: material_path(@material.id)
      end
    end

    context "作り方が存在する時" do
      it "リンクが表示される" do
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

      context "質問があり,返信がない場合" do
        it "質問削除・返信作成リンクが表示される" do
          sign_in @admin
          visit content_show_path(@content.id)
          expect(page).to have_link ">>削除", href: question_path(@do_question)
          expect(page).to have_link ">>返信する", href: new_response_path(question_id: @do_question.id)
        end
      end

      context "質問があり,返信がある場合" do
        it "返信編集・返信削除リンクが表示される" do
          sign_in @admin
          visit content_show_path(@content.id)
          expect(page).to have_link ">>編集", href: edit_response_path(@end_question.response, question_id: @end_question.id)
          expect(page).to have_link ">>削除", href: response_path(@end_question.response)
        end

        it "質問を削除するリンクが表示されない" do
          sign_in @admin
          visit content_show_path(@content.id)
          expect(page).not_to have_link ">>削除", href: question_path(@end_question)
        end
      end
    end
  end
end
