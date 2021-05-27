class ApplicationController < ActionController::Base
  def redirect_root
    redirect_back(fallback_location: root_path) and return
  end

  def admin_checker
    redirect_to root_path, alert: "不正なアクセスです" and return unless user_signed_in?     # ログインしているか
    redirect_to root_path, alert: "不正なアクセスです" and return unless current_user.admin? # ログインユーザーが管理者か
  end
end
