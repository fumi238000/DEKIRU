require "rails_helper"

RSpec.describe "Users", type: :request do
  before do
    @user = FactoryBot.create(:user) # ユーザー
    @admin = create(:user, user_type: "admin", email: ENV["MAIL_ADMIN"]) # 管理者
    @edit_user = FactoryBot.create(:user) # ユーザー
  end

  describe "GET /index" do
    subject { get(users_path) }

    context "未ログインユーザーの場合" do
      it "リダイレクトする" do
        subject
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "リダイレクトする" do
        subject
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "管理者の場合" do
      it "マイページに遷移する" do
        sign_in @admin
        subject
        expect(response).to have_http_status(:ok)
      end
    end
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

  describe "GET /update" do
    subject { patch(user_path(user.id), params: user_params) }

    let(:user) { @edit_user }
    let(:user_params) {
      { user: {
        user_type: "discontinued",
      } }
    }

    context "未ログインユーザーの場合" do
      it "リダイレクトする" do
        subject
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "リダイレクトする" do
        subject
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "管理者の場合" do
      it "userが更新される" do
        sign_in @admin
        new_user = user_params[:user]
        expect { subject }.to change { user.reload.user_type }.from(user.user_type).to(new_user[:user_type])
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to users_path
        expect(flash[:notice]).to eq("ユーザーのステータスを更新しました")
      end
    end
  end

  describe "GET /edit" do
    subject { get(edit_user_path(user_id)) }

    let(:user_id) { @edit_user.id }

    context "未ログインユーザーの場合" do
      it "リダイレクトする" do
        subject
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "リダイレクトする" do
        subject
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "管理者の場合" do
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
