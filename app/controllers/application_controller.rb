class ApplicationController < ActionController::Base
  def redirect_root
    redirect_back(fallback_location: root_path) and return
  end

  def admin_checker
    redirect_to root_path, alert: "不正なアクセスです" and return unless user_signed_in?     # ログインしているか
    redirect_to root_path, alert: "不正なアクセスです" and return unless current_user.admin? # ログインユーザーが管理者か
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

    def configure_permitted_parameters
      # 新規登録用ストロングパラメータ
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :thumbnail])
      # アカウント編集用ストロングパラメータ
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :thumbnail])
    end
end
