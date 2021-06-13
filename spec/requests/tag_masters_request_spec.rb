require "rails_helper"

RSpec.describe "TagMasters", type: :request do
  before do
    @user = FactoryBot.create(:user) # ユーザー
    @admin = FactoryBot.create(:user, user_type: "admin") # 管理者
  end

  describe "GET #new" do
    subject { get(new_tag_master_path) }

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
    subject { post(tag_masters_path, params: tag_master_params) }

    let(:content) { create(:content) }
    let(:tag_master_params) { { tag_master: attributes_for(:tag_master) } }

    context "未ログインユーザの場合" do
      it "タグの件数が変化しないこと" do
        expect { subject }.to change { TagMaster.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "タグの件数が変化しないこと" do
        sign_in @user
        expect { subject }.to change { TagMaster.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "管理者の場合" do
      context "パラメータが正常な時" do
        it "タグの件数が1件増加すること" do
          sign_in @admin
          expect { subject }.to change { TagMaster.count }.by(1)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to mypage_path(@admin)
          expect(flash[:notice]).to eq("タグを追加しました")
        end
      end

      context "パラメータが異常な時" do
        let(:tag_master_params) { { tag_master: attributes_for(:tag_master, :tag_master_invalid) } }
        it "タグの件数が増加しないこと" do
          sign_in @admin
          expect { subject }.to change { TagMaster.count }.by(0)
          expect(response).to have_http_status(:ok)
          expect(response.body).to include "タグを追加"
        end
      end
    end
  end

  describe "PUT #update" do
    subject { patch(tag_master_path(tag_master.id), params: tag_master_params) }

    let(:tag_master) { create(:tag_master) }
    let(:tag_master_params) { { tag_master: attributes_for(:tag_master) } }

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
        it "タグが更新されること" do
          sign_in @admin
          new_tag_master = tag_master_params[:tag_master]
          expect { subject }.to change { tag_master.reload.tag_name }.from(tag_master.tag_name).to(new_tag_master[:tag_name])
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to mypage_path(@admin)
          expect(flash[:notice]).to eq("タグを更新しました")
        end
      end

      context "パラメータが異常な時" do
        let(:tag_master_params) { { tag_master: attributes_for(:tag_master, :tag_master_invalid) } }

        it "タグが更新できないこと" do
          sign_in @admin
          expect { subject }.not_to change { tag_master.reload.tag_name }
          expect(response).to have_http_status(:ok)
          expect(response.body).to include "タグを編集"
        end
      end
    end
  end

  describe "GET #edit" do
    subject { get(edit_tag_master_path(tag_master_id)) }

    let(:tag_master) { create(:tag_master) }
    let(:tag_master_id) { tag_master.id }

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
      it "指定したidの「タグ名」が表示されること" do
        sign_in @admin
        subject
        expect(response.body).to include tag_master.tag_name
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET #destroy" do
    subject { delete(tag_master_path(@tag_master.id)) }

    before { @tag_master = create(:tag_master) }

    context "未ログインユーザーの場合" do
      it "リダイレクトされること" do
        expect { subject }.to change { TagMaster.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "リダイレクトされること" do
        sign_in @user
        expect { subject }.to change { TagMaster.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "管理者の場合" do
      it "タグが削除されること" do
        sign_in @admin
        expect { subject }.to change { TagMaster.count }.by(-1)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to mypage_path(@admin)
        expect(flash[:alert]).to eq("タグを削除しました")
      end
    end
  end
end
