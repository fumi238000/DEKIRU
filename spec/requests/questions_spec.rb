require "rails_helper"

RSpec.describe "Questions", type: :request do
  before do
    @user = FactoryBot.create(:user) # ユーザー
    @admin = FactoryBot.create(:user, user_type: "admin") # 管理者
  end

  # describe "GET #index" do
  #   xit "質問一覧画面" do
  #   end
  # end

  describe "POST #create" do
    subject { post(questions_path, params: question_params) }

    let(:question_params) { { question: attributes_for(:question) } }

    context "未ログインユーザの場合" do
      it "質問の件数が変化しないこと" do
        expect { subject }.to change { Question.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    # Question#newから送信されていないからエラーが発生しているっぽい
    context "一般ユーザーの場合" do
      context "パラメータが正常な時" do
        let(:content) { create(:content) }
        let(:question_params) { { question: attributes_for(:question, content_id: content.id) } }
        it "質問の件数が1件増加すること" do
          sign_in @user
          expect { subject }.to change { Question.count }.by(1)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to content_show_path(Question.last.content.id)
          expect(flash[:notice]).to eq("質問を作成しました。返信をお待ちください。")
        end
      end

      context "パラメータが異常な時" do
        let(:question_params) { { question: attributes_for(:question, :question_invalid, user_id: @user.id) } }

        xit "質問の件数が増加しないこと" do
          sign_in @user
          expect { subject }.to change { Question.count }.by(0)
          expect(response).to have_http_status(:ok)
          # TODO: エラーメッセージが表示されること
          # リダイレクトするか検討中
          # expect(response.body).to include "を入力してください"
        end
      end
    end

    context "管理者の場合" do
      it "質問の件数が変化しないこと" do
        sign_in @admin
        expect { subject }.to change { Question.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("管理者はこの操作を行うことができません")
      end
    end
  end

  describe "GET #destroy" do
    subject { delete(question_path(@question.id)) }

    before { @question = create(:question) }

    context "未ログインユーザーの場合" do
      it "リダイレクトされること" do
        expect { subject }.to change { Question.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "リダイレクトされること" do
        sign_in @user
        expect { subject }.to change { Question.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "管理者の場合" do
      it "質問が削除されること" do
        sign_in @admin
        expect { subject }.to change { Question.count }.by(-1)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to content_show_path(@question.content)
        expect(flash[:alert]).to eq("質問を削除しました")
      end
    end
  end
end
