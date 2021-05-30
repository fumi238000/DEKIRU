require "rails_helper"

RSpec.describe "Contents", type: :request do
  before do
    @user = FactoryBot.create(:user) # ユーザー
    @admin = FactoryBot.create(:user, user_type: "admin") # 管理者
  end

  describe "GET #index" do
    subject { get(contents_path) }

    create_content = 3

    context "コンテンツが存在する場合" do
      before { create_list(:content, create_content) }

      it "コンテンツ一覧を取得できること" do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(*Content.pluck(:title))
        # TODO: youtube動画登録機能実装時に使用する
        # expect(response.body).to include(*Content.pluck(:thumbnail))
        expect(Content.count).to eq(create_content)
      end
    end

    # TOOD: capybara部分は別タスクで実行する
    context "画面に遷移した時" do
      context "未ログインユーザーの場合" do
        xit "新規登録ボタンが表示されない" do
          # 表示されない処理
        end
      end

      context "ユーザーが管理者でない場合" do
        xit "新規登録ボタンが表示されない" do
          sign_in @admin
          # 表示されない処理
        end
      end

      context "ユーザーが管理者の場合" do
        xit "新規登録ボタンが表示される" do
          sign_in @user
          # 表示される処理
        end
      end
    end
  end

  describe "GET #new" do
    subject { get(new_content_path) }

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

      context "ユーザーが管理者の場合" do
        it "リスクエストが成功する" do
          sign_in @admin
          subject
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe "GET #show" do
    subject { get(content_show_path(content_id)) }

    context "コンテンツが存在するとき" do
      let(:content) { create(:content) }
      let(:content_id) { content.id }

      context "コンテンツが存在する場合" do
        it "指定したidのコンテンツが取得できる" do
          subject
          expect(response).to have_http_status(:ok)
          expect(response.body).to include content.title
          expect(response.body).to include content.subtitle
          # expect(response.body).to include content.movie_url
          expect(response.body).to include content.comment
          expect(response.body).to include content.point
        end
      end

      context "コンテンツが存在しない場合" do
        let(:content_id) { 0 }
        it "エラーが発生する" do
          # TODO: 将来404へ遷移する様にする
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

    # TOOD: capybara部分は別タスクで実行する
      context "未ログインユーザーの場合" do
        xit "xxボタンが表示されないこと" do
          # テスト
          # 作り方（追加・編集・削除）
          # 材料
        end
      end

      context "ユーザーが管理者でない場合" do
        xit "xxボタンが表示されないこと" do
          sign_in @user
          # テスト
          # 作り方（追加・編集・削除）
          # 材料
        end
      end

      context "ユーザーが管理者の場合" do
        xit "xxボタンが表示されること" do
          sign_in @admin
          # テスト
          # 作り方（追加・編集・削除）
          # 材料
        end
      end
    end
  end

  describe "POST #create" do
    subject { post(contents_path, params: content_params) }

    let(:content_params) { { content: attributes_for(:content) } }

    context "未ログインユーザの場合" do
      it "コンテンツの件数が変化しないこと" do
        expect { subject }.to change { Content.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "ユーザーが管理者でない場合" do
      it "コンテンツの件数が変化しないこと" do
        sign_in @user
        expect { subject }.to change { Content.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "ユーザーが管理者の場合" do
      it "コンテンツの件数が1件増加すること" do
        sign_in @admin
        expect { subject }.to change { Content.count }.by(1)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to content_show_path(Content.last)
        expect(flash[:notice]).to eq("【#{Content.last.title}】を作成しました")
      end
    end

    describe "PUT #update" do
      subject { patch(content_path(content.id), params: content_params) }

      let(:content) { create(:content) }
      let(:content_params) { { content: attributes_for(:content) } }

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

      context "ユーザーが管理者の場合"

        it "コンテンツが更新されること" do # rubocop:disable all
          sign_in @admin
          new_content = content_params[:content]
          expect { subject }.to change { content.reload.title }.from(content.title).to(new_content[:title]).
                                  and change { content.reload.subtitle }.from(content.subtitle).to(new_content[:subtitle]).
                                        # and change { content.reload.movie_url }.from(content.movie_url).to(new_content[:movie_url]).
                                        and change { content.reload.comment }.from(content.comment).to(new_content[:comment]).
                                              and change { content.reload.point }.from(content.point).to(new_content[:point])
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to content_show_path(Content.last)
          expect(flash[:notice]).to eq("内容を更新しました")
        end
    end
  end

  describe "GET #edit" do
    subject { get(edit_content_path(content_id)) }

    let(:content) { create(:content) }
    let(:content_id) { content.id }

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
      it "指定したidのコンテンツが表示されること" do
        sign_in @admin
        subject
        expect(response.body).to include content.title
        expect(response.body).to include content.subtitle
        expect(response.body).to include content.movie_url
        expect(response.body).to include content.comment
        expect(response.body).to include content.point
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET #destroy" do
    subject { delete(content_path(@content.id)) }

    before { @content = create(:content) }

    context "未ログインユーザーの場合" do
      it "リダイレクトされること" do
        expect { subject }.to change { Content.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "ユーザーが管理者でない場合" do
      it "リダイレクトされること" do
        sign_in @user
        expect { subject }.to change { Content.count }.by(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq("不正なアクセスです")
      end
    end

    context "ユーザーが管理者の場合" do
      before { @content = create(:content) }

      it "コンテンツが削除されること" do
        sign_in @admin
        expect { subject }.to change { Content.count }.by(-1)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to contents_path
        expect(flash[:alert]).to eq("【#{@content.title}】を削除しました")
      end
    end
  end
end
