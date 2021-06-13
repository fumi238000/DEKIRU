require "rails_helper"

RSpec.describe "Users", type: :request do
  before do
    @user = FactoryBot.create(:user) # ユーザー
    @admin = FactoryBot.create(:user, user_type: "admin") # 管理者
  end

  describe "GET /show" do
    subject { get(mypage_path(user_id)) }

    let(:user_id) { @user.id }

    context "未ログインユーザーの場合" do
      it "リダイレクトする" do
        subject
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "マイページに遷移する" do
        sign_in @user
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context "管理者の場合" do
      let(:user_id) { @admin.id }
      it "マイページに遷移する" do
        sign_in @admin
        subject
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /favorite" do
    subject { get(favorite_contents_path(user_id)) }

    let(:user_id) { @user.id }

    context "未ログインユーザーの場合" do
      it "リダイレクトする" do
        subject
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "リクエストが成功する" do
        sign_in @user
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context "管理者の場合" do
      let(:user_id) { @admin.id }
      it "リクエストが成功する" do
        sign_in @admin
        subject
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /admin" do
    subject { get(admin_page_path) }

    context "未ログインユーザーの場合" do
      it "リダイレクトする" do
        subject
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "リダイレクトする" do
        sign_in @user
        subject
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "管理者の場合" do
      it "リクエストが成功する" do
        sign_in @admin
        subject
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
