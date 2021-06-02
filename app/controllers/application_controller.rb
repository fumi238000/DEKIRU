class ApplicationController < ActionController::Base
  before_action :set_search
  before_action :configure_permitted_parameters, if: :devise_controller?

  # 定数 # TODO: 後日別の方法を検討する
  RECOMMEND_CONTENT_NUM = 9 # おすすめコンテンツの最大数
  PER_PAGE = 12 # 1ページの表示数

  def redirect_root
    redirect_back(fallback_location: root_path) and return
  end

  def admin_checker
    redirect_to root_path, alert: "不正なアクセスです" and return unless user_signed_in?     # ログインしているか
    redirect_to root_path, alert: "不正なアクセスです" and return unless current_user.admin? # ログインユーザーが管理者か
  end

  def user_checker
    redirect_to root_path, alert: "不正なアクセスです" and return unless user_signed_in? # ログインしているか
    redirect_to root_path, alert: "管理者はこの操作を行うことができません" and return unless current_user.general? # ログインユーザーが一般ユーザーか
  end

  private

    def configure_permitted_parameters
      # 新規登録用ストロングパラメータ
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :thumbnail])
      # アカウント編集用ストロングパラメータ
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :thumbnail])
    end

    # 検索
    def set_search
      @q = Content.ransack(params[:q]) # 検索対象
      @contents = @q.result.page(params[:page]).per(PER_PAGE) # 検索結果
      @search_word = params[:q].present? ? params[:q][:title_cont] : "" # 検索ワード
    end
end
