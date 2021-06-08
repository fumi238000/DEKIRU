require "rails_helper"

RSpec.describe "Users", type: :feature do
  before do
    @user = create(:user) # ユーザー
    @admin = create(:user, user_type: "admin") # 管理者
    @tag = create(:tag_master)
  end

  describe "GET #show" do
    # MEMO: 未ログインユーザーの場合、遷移できないためテストなし

    context "ユーザーが一般ユーザーの場合" do
      it "管理者専用リンクが表示されないこと" do
        sign_in @user
        visit mypage_path(@user)
        expect(page).not_to have_link ">>追加", href: new_tag_master_path # タグ追加
        expect(page).not_to have_link ">>編集", href: edit_tag_master_path(@tag.id) # タグ編集
        expect(page).not_to have_link ">>削除", href: tag_master_path(@tag.id) # タグ削除
        expect(page).not_to have_link ">>追加", href: new_category_path # カテゴリー追加
        expect(page).not_to have_link ">>新規作成", href: new_content_path # コンテンツ追加
      end
    end

    context "管理者の場合" do
      it "管理者専用リンクが表示されること" do
        sign_in @admin
        visit mypage_path(@admin)
        expect(page).to have_link ">>追加", href: new_tag_master_path # タグ追加
        expect(page).to have_link ">>編集", href: edit_tag_master_path(@tag.id) # タグ編集
        expect(page).to have_link ">>削除", href: tag_master_path(@tag.id) # タグ削除
        expect(page).to have_link ">>追加", href: new_category_path # カテゴリー追加
        expect(page).to have_link ">>新規作成", href: new_content_path # コンテンツ追加
      end
    end
  end
end
