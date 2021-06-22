require "rails_helper"

RSpec.describe "Responses", type: :request do
  before do
    @user = FactoryBot.create(:user) # ユーザー
    @admin = create(:user, user_type: "admin", email: ENV["MAIL_ADMIN"]) # 管理者
  end

  describe "GET #new" do
    subject { get(new_response_path, params: { question_id: question.id }) }

    let(:question) { create(:question) }

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
    subject { post(responses_path, params: response_params) }

    let(:question) { create(:question) }
    let(:response_params) { { response: attributes_for(:response, question_id: question.id) } }

    context "未ログインユーザの場合" do
      it "返信の件数が変化しないこと" do
        expect { subject }.to change { Response.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "返信の件数が変化しないこと" do
        sign_in @user
        expect { subject }.to change { Response.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "管理者の場合" do
      context "パラメータが正常な時" do
        it "返信の件数が1件増加すること" do
          sign_in @admin
          expect { subject }.to change { Response.count }.by(1)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to questions_path
          expect(flash[:notice]).to eq("質問に対して返信しました")
        end
      end

      context "パラメータが異常な時" do
        let(:response_params) { { response: attributes_for(:response, :response_invalid, question_id: question.id) } }
        it "返信の件数が増加しないこと" do
          sign_in @admin
          expect { subject }.to change { Response.count }.by(0)
          expect(response).to have_http_status(:ok)
          expect(response.body).to include "返信する"
        end
      end
    end
  end

  describe "PUT #update" do
    subject { patch(response_path(response_data.id), params: response_params) }

    let(:question) { create(:question) }
    let(:question_id) { question.id }
    let(:response_data) { create(:response, question_id: question_id) }
    let(:response_params) { { response: attributes_for(:response, question_id: question.id) } }

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
        it "返信が更新されること" do
          sign_in @admin
          new_response = response_params[:response]
          expect { subject }.to change { response_data.reload.response_content }.from(response_data.response_content).to(new_response[:response_content])
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to content_show_path(response_data.question.content.id)
          expect(flash[:notice]).to eq("返信内容を更新しました")
        end
      end

      context "パラメータが異常な時" do
        let(:response_params) { { response: attributes_for(:response, :response_invalid, question_id: question.id) } }

        it "返信が更新できないこと" do
          sign_in @admin
          expect { subject }.not_to change { response_data.reload.response_content }
          expect(response).to have_http_status(:ok)
          expect(response.body).to include "返信を編集する"
        end
      end
    end
  end

  describe "GET #edit" do
    subject { get(edit_response_path(response_id, question_id: question.id)) }

    let(:question) { create(:question) }
    let(:response_data) { create(:response, question_id: question.id) }
    let(:response_id) { response_data.id }

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
      it "指定したidの「返信」が表示されること" do
        sign_in @admin
        subject
        expect(response.body).to include response_data.response_content
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET #destroy" do
    subject { delete(response_path(@response_data.id)) }

    before { @response_data = create(:response) }

    context "未ログインユーザーの場合" do
      it "リダイレクトされること" do
        expect { subject }.to change { Response.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      it "リダイレクトされること" do
        sign_in @user
        expect { subject }.to change { Response.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "管理者の場合" do
      it "返信が削除されること" do
        sign_in @admin
        expect { subject }.to change { Response.count }.by(-1)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to content_show_path(@response_data.question.content.id)
        expect(flash[:alert]).to eq("返信内容を削除しました")
      end
    end
  end
end
