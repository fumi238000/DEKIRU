# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :discontinued_user_checker, only: [:create] # rubocop:disable all

  # ゲストアカウントでログイン
  def guest_sign_in
    sign_in User.guest
    User.create_sample_date
    flash[:gest_login] = "ゲストユーザーとしてログインしました。「レビュー」「質問」「お気に入り」が実施できます"
    redirect_to root_path
  end

  protected

    # 停止ユーザーはログインできない
    def discontinued_user_checker
      user = User.find_by(email: params[:user][:email].downcase)
      return if user.blank?

      redirect_to new_user_session_path, alert: "このアカウントではログインすることができません。" if user.discontinued?
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
