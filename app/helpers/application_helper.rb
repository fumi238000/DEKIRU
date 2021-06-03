module ApplicationHelper
  ## TODO: リファクタリングを検討する
  def admin_user?
    if user_signed_in?
      current_user.admin?
    end
  end

  def general_user?
    if user_signed_in?
      current_user.general?
    end
  end
end
