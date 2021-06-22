require "rails_helper"

RSpec.describe "Users", type: :feature do
  before do
    @user = create(:user) # ユーザー
    @admin = create(:user, user_type: "admin", email: ENV["MAIL_ADMIN"]) # 管理者
    @tag = create(:tag_master)
  end

  describe "GET #show" do
    # MEMO: 未ログインユーザーの場合、遷移できないためテストなし

    context "ユーザーが一般ユーザーの場合" do
      it "管理者専用リンクが表示されないこと" do
        sign_in @user
        visit mypage_path(@user)
        expect(page).not_to have_link "管理者画面へ", href: admin_page_path
      end
    end

    context "管理者の場合" do
      it "管理者専用リンクが表示されること" do
        sign_in @admin
        visit mypage_path(@admin)
        expect(page).to have_link "管理者画面へ", href: admin_page_path
      end
    end
  end
end
