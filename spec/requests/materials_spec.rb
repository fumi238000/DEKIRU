require "rails_helper"

RSpec.describe "Materials", type: :request do
  before do
    @user = FactoryBot.create(:user) # ユーザー
    @admin = FactoryBot.create(:user, user_type: "admin") # 管理者
  end

  describe "GET #new" do
    subject { get(new_material_path) }

    context "未ログインユーザーの場合" do
      it "リダイレクトする" do
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "ユーザーが管理者でない場合" do
      it "リダイレクトする" do
        sign_in @user
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "ユーザーが管理者の場合" do
      it "リスクエストが成功する" do
        sign_in @admin
        subject
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST #create" do
    subject { post(materials_path, params: material_params) }

    let(:content) { create(:content) }
    let(:material_params) { { material: attributes_for(:material, content_id: content.id) } }

    context "未ログインユーザの場合" do
      it "コンテンツの件数が変化しないこと" do
        expect { subject }.to change { Material.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "ユーザーが管理者でない場合" do
      it "コンテンツの件数が変化しないこと" do
        sign_in @user
        expect { subject }.to change { Material.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "ユーザーが管理者の場合" do
      context "パラメータが正常な時" do
        it "コンテンツの件数が1件増加すること" do
          sign_in @admin
          expect { subject }.to change { Material.count }.by(1)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to content_show_path(Material.last.content)
          expect(flash[:notice]).to eq("材料を追加しました")
        end
      end

      context "パラメータが異常な時" do
        let(:material_params) { { material: attributes_for(:material, :material_invalid, content_id: content.id) } }
        it "コンテンツの件数が増加しないこと" do
          sign_in @admin
          expect { subject }.to change { Material.count }.by(0)
          expect(response).to have_http_status(:ok)
          # TODO: エラーメッセージが表示されること
          # expect(response.body).to include "を入力してください"
        end
      end
    end
  end

  describe "PUT #update" do
    subject { patch(material_path(material.id), params: material_params) }

    let(:content) { create(:content) }
    let(:content_id) { content.id }
    let(:material) { create(:material, content_id: content_id) }
    let(:material_params) { { material: attributes_for(:material, content_id: content_id) } }

    context "未ログインユーザーの場合" do
      it "リダイレクトすること" do
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "ユーザーが管理者でない場合" do
      it "リダイレクトすること" do
        sign_in @user
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "ユーザーが管理者の場合" do
      context "パラメータが正常な時" do
        it "材料が更新されること" do
          sign_in @admin
          new_material = material_params[:material]
          expect { subject }.to change { material.reload.name }.from(material.name).to(new_material[:name]).
                                  and change { material.reload.amount }.from(material.amount).to(new_material[:amount]).
                                        and change { material.reload.unit }.from(material.unit).to(new_material[:unit])
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to content_show_path(material.content)
          expect(flash[:notice]).to eq("材料を更新しました")
        end
      end

      context "パラメータが異常な時" do
        let(:material_params) { { material: attributes_for(:material, :material_invalid, content_id: content.id) } }

        it "材料が更新できないこと" do
          sign_in @admin
          expect { subject }.not_to change { material.reload.name }
          expect { subject }.not_to change { material.reload.amount }
          expect { subject }.not_to change { material.reload.unit }
          expect(response).to have_http_status(:ok)
          # TODO: エラーメッセージが表示されること
          # expect(response.body).to include "を入力してください"
        end
      end
    end
  end

  describe "GET #edit" do
    subject { get(edit_material_path(material_id, content_id: content.id)) }

    let(:content) { create(:content) }
    let(:material) { create(:material, content_id: content.id) }
    let(:material_id) { material.id }

    context "未ログインユーザーの場合" do
      it "リダイレクトされること" do
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "ユーザーが管理者でない場合" do
      it "リダイレクトされること" do
        sign_in @user
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "ユーザーが管理者の場合" do
      it "指定したidの「材料」が表示されること" do
        sign_in @admin
        subject
        expect(response.body).to include material.name
        expect(response.body).to include material.amount.to_s
        expect(response.body).to include material.unit
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET #destroy" do
    subject { delete(material_path(@material.id)) }

    let(:content) { create(:content) }
    before { @material = create(:material, content_id: content.id) }

    context "未ログインユーザーの場合" do
      it "リダイレクトされること" do
        expect { subject }.to change { Material.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "ユーザーが管理者でない場合" do
      it "リダイレクトされること" do
        sign_in @user
        expect { subject }.to change { Material.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "ユーザーが管理者の場合" do
      it "コンテンツが削除されること" do
        sign_in @admin
        expect { subject }.to change { Material.count }.by(-1)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to content_show_path(@material.content)
        expect(flash[:alert]).to eq("材料を削除しました")
      end
    end
  end
end
