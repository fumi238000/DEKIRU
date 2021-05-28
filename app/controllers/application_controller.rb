class ApplicationController < ActionController::Base
  def redirect_root
    redirect_back(fallback_location: root_path) and return
  end

  def admin_checker
    redirect_to root_path, alert: "不正なアクセスです" and return unless user_signed_in?     # ログインしているか
    redirect_to root_path, alert: "不正なアクセスです" and return unless current_user.admin? # ログインユーザーが管理者か
  end

  # TODO: 入力箇所を検討すること
  before_action :configure_permitted_parameters, if: :devise_controller?

  # TODO: 入力箇所を検討すること
  protected

    # 新規登録用ストロングパラメータ
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end
end
