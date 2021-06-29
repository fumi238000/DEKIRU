# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_normal_user, only: %i[edit destroy] # rubocop:disable all

  def ensure_normal_user
    if resource.email == "guest@example.com"
      redirect_to mypage_path(current_user), notice: "ゲストユーザーの更新・削除はできません。"
    end
  end

  protected

    # 更新時にパスワード入力を省略
    def update_resource(resource, params)
      resource.update_without_password(params)
    end

    # アカウント編集後のリダイレクト先
    def after_update_path_for(resource)
      mypage_path(current_user)
    end
end
