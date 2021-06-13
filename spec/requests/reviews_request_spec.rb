require "rails_helper"

RSpec.describe "Reviews", type: :request do
  before do
    @user = FactoryBot.create(:user) # ユーザー
    @admin = FactoryBot.create(:user, user_type: "admin") # 管理者
    @content = create(:content, public_status: "published")
  end

  describe "GET #new" do
    subject { get(new_review_path, params: { content_id: @content.id }) }

    context "未ログインユーザーの場合" do
      it "リダイレクトする" do
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to user_session_path
        expect(flash[:alert]).to eq("ログインもしくはアカウント登録してください。")
      end
    end

    context "一般ユーザーの場合" do
      it "リスクエストが成功する" do
        sign_in @user
        subject
        expect(response).to have_http_status(:ok)
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

  describe "POST #create" do
    subject { post(reviews_path, params: review_params) }

    let(:review_params) { { review: attributes_for(:review, content_id: @content.id) } }

    context "未ログインユーザの場合" do
      it "コンテンツの件数が変化しないこと" do
        expect { subject }.to change { Review.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to user_session_path
        expect(flash[:alert]).to eq("ログインもしくはアカウント登録してください。")
      end
    end

    context "一般ユーザーの場合" do
      context "パラメータが正常な時" do
        it "レビューの件数が1件増加すること" do
          sign_in @user
          expect { subject }.to change { Review.count }.by(1)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to content_show_path(Review.last.content)
          expect(flash[:notice]).to eq("レビューを追加しました")
        end
      end

      context "パラメータが異常な時" do
        let(:review_params) { { review: attributes_for(:review, :review_invalid, content_id: @content.id) } }
        it "レビューの件数が増加しないこと" do
          sign_in @user
          expect { subject }.to change { Review.count }.by(0)
          expect(response).to have_http_status(:ok)
          # TODO: エラーメッセージが表示されること
          # expect(response.body).to include "を入力してください"
        end
      end
    end

    context "管理者の場合" do
      context "パラメータが正常な時" do
        it "レビューの件数が1件増加すること" do
          sign_in @admin
          expect { subject }.to change { Review.count }.by(1)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to content_show_path(Review.last.content)
          expect(flash[:notice]).to eq("レビューを追加しました")
        end
      end

      context "パラメータが異常な時" do
        let(:review_params) { { review: attributes_for(:review, :review_invalid, content_id: @content.id) } }
        it "レビューの件数が増加しないこと" do
          sign_in @admin
          expect { subject }.to change { Review.count }.by(0)
          expect(response).to have_http_status(:ok)
          # TODO: エラーメッセージが表示されること
          # expect(response.body).to include "を入力してください"
        end
      end
    end

    describe "GET #destroy" do
      subject { delete(review_path(@review.id)) }

      context "未ログインユーザーの場合" do
        it "リダイレクトされること" do
          expect { subject }.to change { Review.count }.by(0)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to new_user_session_path
          expect(flash[:alert]).to eq("ログインもしくはアカウント登録してください。")
        end
      end

      context "一般ユーザーの場合" do
        context "自分の投稿したレビューの場合" do
          before { @review = create(:review, user_id: @user.id) }

          it "レビューが削除されること", type: :do do
            sign_in @user
            expect { subject }.to change { Review.count }.by(-1)
            expect(response).to have_http_status(:found)
            expect(response).to redirect_to content_show_path(@review.content)
            expect(flash[:alert]).to eq("レビューを削除しました")
          end
        end

        context "自分の投稿したレビューでない場合" do
          let(:user) { create(:user) }
          it "リダイレクトされること" do
            sign_in user
            expect { subject }.to change { Review.count }.by(0)
            expect(response).to have_http_status(:found)
            expect(response).to redirect_to root_path
            expect(flash[:alert]).to eq("権限がありません")
          end
        end
      end

      context "管理者の場合" do
        before { @review = create(:review, user_id: @user.id) }

        it "レビューが削除されること", type: :do do
          sign_in @admin
          expect { subject }.to change { Review.count }.by(-1)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to content_show_path(@review.content)
          expect(flash[:alert]).to eq("レビューを削除しました")
        end
      end
    end
  end
end
