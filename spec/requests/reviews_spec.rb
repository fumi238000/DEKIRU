require "rails_helper"

RSpec.describe "Reviews", type: :request do
  before do
    @user = FactoryBot.create(:user) # ユーザー
    @admin = FactoryBot.create(:user, user_type: "admin") # 管理者
  end

  describe "GET #new" do
    subject { get(new_review_path) }

    context "未ログインユーザーの場合" do
      it "リダイレクトする" do
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to user_session_path
        expect(flash[:alert]).to eq("ログインもしくはアカウント登録してください。")
      end
    end

    context "ユーザーが管理者でない場合" do
      it "リスクエストが成功する" do
        sign_in @user
        subject
        expect(response).to have_http_status(:ok)
      end

      context "ユーザーが管理者の場合" do
        it "リスクエストが成功する" do
          sign_in @admin
          subject
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe "POST #create" do
    subject { post(reviews_path, params: review_params) }

    let(:content) { create(:content) }
    let(:review_params) { { review: attributes_for(:review, content_id: content.id) } }

    context "未ログインユーザの場合" do
      it "コンテンツの件数が変化しないこと" do
        expect { subject }.to change { Review.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to user_session_path
        expect(flash[:alert]).to eq("ログインもしくはアカウント登録してください。")
      end
    end

    context "ユーザーが管理者でない場合" do
      context "パラメータが正常な時" do
        xit "レビューの件数が1件増加すること" do
          sign_in @user
          expect { subject }.to change { Review.count }.by(1)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to content_show_path(Review.last.content)
          expect(flash[:notice]).to eq("レビューを追加しました")
        end
      end

      context "パラメータが異常な時" do
        let(:review_params) { { review: attributes_for(:review, :review_invalid, content_id: content.id) } }
        it "レビューの件数が増加しないこと" do
          sign_in @user
          expect { subject }.to change { Review.count }.by(0)
          expect(response).to have_http_status(:ok)
          # TODO: エラーメッセージが表示されること
          # expect(response.body).to include "を入力してください"
        end
      end
    end

    # TODO: 検討する
    context "ユーザーが管理者の場合" do
      context "パラメータが正常な時" do
        xit "レビューの件数が1件増加すること" do
          sign_in @admin
          expect { subject }.to change { Review.count }.by(1)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to content_show_path(Review.last.content)
          expect(flash[:notice]).to eq("レビューを追加しました")
        end
      end

      context "パラメータが異常な時" do
        let(:review_params) { { review: attributes_for(:review, :review_invalid, content_id: content.id) } }
        it "レビューの件数が増加しないこと" do
          sign_in @admin
          expect { subject }.to change { Review.count }.by(0)
          expect(response).to have_http_status(:ok)
          # TODO: エラーメッセージが表示されること
          # expect(response.body).to include "を入力してください"
        end
      end
    end

  # TODO: 削除機能を追加した場合、destroyのテストを実装すること
  end
end
