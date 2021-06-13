# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # ゲストアカウントでログイン
  def guest_sign_in
    sign_in User.guest
    User.create_guest_sample_date
    redirect_to root_path, notice: "ゲストユーザーとしてログインしました。「レビュー」「質問」「お気に入り」「お問い合わせ」が実施できます"
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
