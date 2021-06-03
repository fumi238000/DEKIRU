# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_normal_user, only: %i[destroy] # rubocop:disable all

  def ensure_normal_user
    if resource.email == "guest@example.com"
      redirect_to root_path, alert: "ゲストユーザーの更新・削除はできません。"
    end
  end

  protected

     # アカウント編集後のリダイレクト先
    def after_update_path_for(resource)
      mypage_path(current_user)
    end
end
