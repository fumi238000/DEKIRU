require "rails_helper"

RSpec.describe "Categories", type: :request do
  before do
    @user = FactoryBot.create(:user) # ユーザー
    @admin = FactoryBot.create(:user, user_type: "admin") # 管理者
  end

  describe "GET #index" do
    subject { get(categories_path) }

    create_category = 3

    context "カテゴリーが存在する場合" do
      before { create_list(:category, create_category) }

      it "カテゴリー一覧を取得できること" do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(*Category.pluck(:name))
        expect(Category.count).to eq(create_category)
      end
    end
  end

  describe "GET #new" do
    subject { get(new_category_path) }

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

      context "管理者の場合" do
        it "リスクエストが成功する" do
          sign_in @admin
          subject
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe "GET #show" do
    subject { get(category_path(category_id)) }

    context "カテゴリーが存在するとき" do
      let(:category) { create(:category) }
      let(:category_id) { category.id }

      context "カテゴリーが存在する場合" do
        it "指定したidのカテゴリーが取得できる" do
          subject
          expect(response).to have_http_status(:ok)
          expect(response.body).to include category.name
        end
      end

      context "カテゴリーが存在しない場合" do
        let(:category_id) { 0 }
        it "エラーが発生する" do
          # TODO: 将来404へ遷移する様にする
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "POST #create" do
    subject { post(categories_path, params: category_params) }

    let(:category_params) { { category: attributes_for(:category) } }

    context "未ログインユーザの場合" do
      it "カテゴリーの件数が変化しないこと" do
        expect { subject }.to change { Category.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "カテゴリーの件数が変化しないこと" do
        sign_in @user
        expect { subject }.to change { Category.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "管理者の場合" do
      context "パラメータが正常な時" do
        it "カテゴリーの件数が1件増加すること" do
          sign_in @admin
          expect { subject }.to change { Category.count }.by(1)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to categories_path
          expect(flash[:notice]).to eq("カテゴリーを作成しました")
        end
      end

      context "パラメータが異常な時" do
        let(:category_params) { { category: attributes_for(:category, :category_invalid) } }

        it "カテゴリーの件数が増加しないこと" do
          sign_in @admin
          expect { subject }.to change { Category.count }.by(0)
          expect(response).to have_http_status(:ok)
          # TODO: エラーメッセージが表示されること
          # expect(response.body).to include "を入力してください"
        end
      end
    end

    describe "PUT #update" do
      subject { patch(category_path(category.id), params: category_params) }

      let(:category) { create(:category) }
      let(:category_params) { { category: attributes_for(:category) } }

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

      context "管理者の場合"
      context "パラメータが正常な時" do
        it "カテゴリーが更新されること" do
          sign_in @admin
          new_category = category_params[:category]
          expect { subject }.to change { category.reload.name }.from(category.name).to(new_category[:name])
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to categories_path
          expect(flash[:notice]).to eq("カテゴリーを更新しました")
        end
      end

      context "パラメータが異常な時" do
        let(:category_params) { { category: attributes_for(:category, :category_invalid) } }

        it "カテゴリーが更新できないこと" do
          sign_in @admin
          expect { subject }.not_to change { category.reload }
          expect(response).to have_http_status(:ok)
          # TODO: エラーメッセージが表示されること
          # expect(response.body).to include "を入力してください"
        end
      end
    end
  end

  describe "GET #edit" do
    subject { get(edit_category_path(category_id)) }

    let(:category) { create(:category) }
    let(:category_id) { category.id }

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
      it "指定したidのカテゴリーが表示されること" do
        sign_in @admin
        subject
        expect(response.body).to include category.name
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET #destroy" do
    subject { delete(category_path(@category.id)) }

    before { @category = create(:category) }

    context "未ログインユーザーの場合" do
      it "リダイレクトされること" do
        expect { subject }.to change { Category.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "リダイレクトされること" do
        sign_in @user
        expect { subject }.to change { Category.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "管理者の場合" do
      it "カテゴリーが削除されること" do
        sign_in @admin
        expect { subject }.to change { Category.count }.by(-1)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to categories_path
        expect(flash[:alert]).to eq("カテゴリーを削除しました")
      end
    end
  end
end
