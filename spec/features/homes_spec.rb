require "rails_helper"

RSpec.describe "Homes", type: :feature do
  before do
    @user = create(:user) # ユーザー
    @admin = create(:user, user_type: "admin") # 管理者
    @tag = create(:tag_master)
  end

  describe "GET #index" do
    context "未ログインユーザーの場合" do
      it "管理者専用リンクが表示されない" do
        visit root_path
        expect(page).not_to have_link ">>編集", href: edit_tag_master_path(@tag.id) # タグ編集
        expect(page).not_to have_link ">>削除", href: tag_master_path(@tag.id) # タグ削除
      end
    end

    context "ユーザーが一般ユーザーの場合" do
      it "管理者専用リンクが表示されない" do
        sign_in @user
        visit root_path
        expect(page).not_to have_link ">>編集", href: edit_tag_master_path(@tag.id) # タグ編集
        expect(page).not_to have_link ">>削除", href: tag_master_path(@tag.id) # タグ削除
      end
    end

    context "管理者の場合" do
      it "管理者専用リンクが表示される" do
        sign_in @admin
        visit root_path
        expect(page).to have_link ">>編集", href: edit_tag_master_path(@tag.id) # タグ編集
        expect(page).to have_link ">>削除", href: tag_master_path(@tag.id) # タグ削除
      end
    end
  end
end
