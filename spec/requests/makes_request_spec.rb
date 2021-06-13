require "rails_helper"

RSpec.describe "Makes", type: :request do
  before do
    @user = FactoryBot.create(:user) # ユーザー
    @admin = FactoryBot.create(:user, user_type: "admin") # 管理者
    @content = create(:content, public_status: "published")
  end

  describe "GET #new" do
    subject { get(new_make_path, params: { content_id: @content.id }) }

    context "未ログインユーザーの場合" do
      it "リダイレクトする" do
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "リダイレクトする" do
        sign_in @user
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "管理者の場合" do
      it "リスクエストが成功する" do
        sign_in @admin
        subject
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST #create" do
    subject { post(makes_path, params: make_params) }

    let(:make_params) { { make: attributes_for(:make, content_id: @content.id) } }

    context "未ログインユーザの場合" do
      it "コンテンツの件数が変化しないこと" do
        expect { subject }.to change { Make.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "コンテンツの件数が変化しないこと" do
        sign_in @user
        expect { subject }.to change { Make.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "管理者の場合" do
      context "パラメータが正常な時" do
        it "コンテンツの件数が1件増加すること" do
          sign_in @admin
          expect { subject }.to change { Make.count }.by(1)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to content_show_path(Make.last.content)
          expect(flash[:notice]).to eq("作り方を追加しました")
        end
      end

      context "パラメータが異常な時" do
        let(:make_params) { { make: attributes_for(:make, :make_invalid, content_id: @content.id) } }
        it "コンテンツの件数が増加しないこと" do
          sign_in @admin
          expect { subject }.to change { Make.count }.by(0)
          expect(response).to have_http_status(:ok)
          # TODO: エラーメッセージが表示されること
          # expect(response.body).to include "を入力してください"
        end
      end
    end
  end

  describe "PUT #update" do
    subject { patch(make_path(make.id), params: make_params) }

    let(:content_id) { @content.id }
    let(:make) { create(:make, content_id: content_id) }
    let(:make_params) { { make: attributes_for(:make, content_id: content_id) } }

    context "未ログインユーザーの場合" do
      it "リダイレクトすること" do
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "リダイレクトすること" do
        sign_in @user
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "管理者の場合" do
      context "パラメータが正常な時" do
        it "コンテンツが更新されること" do
          sign_in @admin
          new_make = make_params[:make]
          expect { subject }.to change { make.reload.detail }.from(make.detail).to(new_make[:detail])
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to content_show_path(make.content)
          expect(flash[:notice]).to eq("作り方を更新しました")
        end
      end

      context "パラメータが異常な時" do
        let(:make_params) { { make: attributes_for(:make, :make_invalid, content_id: @content.id) } }

        it "コンテンツが更新できないこと", type: :do do
          sign_in @admin
          expect { subject }.not_to change { make.reload.detail }
          expect(response).to have_http_status(:ok)
          # TODO: エラーメッセージが表示されること
          # expect(response.body).to include "を入力してください"
        end
      end
    end
  end

  describe "GET #edit" do
    subject { get(edit_make_path(make_id, content_id: @content.id)) }

    let(:make) { create(:make, content_id: @content.id) }
    let(:make_id) { make.id }

    context "未ログインユーザーの場合" do
      it "リダイレクトされること" do
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "リダイレクトされること" do
        sign_in @user
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "管理者の場合" do
      it "指定したidの「作り方」が表示されること" do
        sign_in @admin
        subject
        expect(response.body).to include make.detail
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET #destroy" do
    subject { delete(make_path(@make.id)) }

    before { @make = create(:make, content_id: @content.id) }

    context "未ログインユーザーの場合" do
      it "リダイレクトされること" do
        expect { subject }.to change { Make.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "リダイレクトされること" do
        sign_in @user
        expect { subject }.to change { Make.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "管理者の場合" do
      it "コンテンツが削除されること" do
        sign_in @admin
        expect { subject }.to change { Make.count }.by(-1)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to content_show_path(@make.content)
        expect(flash[:alert]).to eq("作り方を削除しました")
      end
    end
  end
end
