require "rails_helper"

RSpec.describe "Contacts", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @admin = create(:user, user_type: "admin", email: ENV["MAIL_ADMIN"]) # 管理者
  end

  describe "GET #index" do
    subject { get(contacts_path) }

    context "未ログインユーザの場合" do
      it "リダイレクトする" do
        subject
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to eq("不正なアクセスです")
        expect(response).to redirect_to root_path
      end
    end

    context "一般ユーザーの場合" do
      it "リクエストに成功する" do
        sign_in @user
        subject
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to eq("不正なアクセスです")
        expect(response).to redirect_to root_path
      end
    end

    context "管理者の場合" do
      it "リクエストに成功する" do
        sign_in @admin
        subject

        expect(response).to have_http_status(:ok)
      end
    end
  end

  # MEMO: 管理者はスキップ
  describe "GET #new" do
    subject { get(new_contact_path) }

    context "未ログインユーザの場合" do
      it "リダイレクトする" do
        subject
        expect(response).to have_http_status(:found)
        expect(flash[:alert]).to eq("不正なアクセスです")
        expect(response).to redirect_to root_path
      end
    end

    context "一般ユーザーの場合" do
      it "リクエストに成功する" do
        sign_in @user
        subject
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST #create" do
    subject { post(contacts_path, params: { contact: attributes_for(:contact) }) }

    context "未ログインユーザの場合" do
      it "リダイレクトする" do
        expect { subject }.to change { Contact.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:notice]).not_to be_present
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "一般ユーザーの場合" do
      let(:new_contact) { attributes_for(:contact, user_id: @user.id) }

      it "お問い合わせができること" do
        sign_in @user
        expect { subject }.to change { Contact.count }.by(1)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:notice]).to be_present
        expect(flash[:notice]).to eq("お問い合わせ内容を受け付けました。")
      end

      # TODO: メール機能を実装するタイミングで実装する
      # xit "お問い合わせを作成したタイミングで、メールが2件送信されること" do
      #   sign_in @user
      #   expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(2)
      #   mail = ActionMailer::Base.deliveries.last
      #   expect(mail.from[0]).to eq(ENV["MAIL_SYSTEM"])
      # end
    end
  end
end
