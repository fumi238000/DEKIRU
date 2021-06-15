class UsersController < ApplicationController
  before_action :set_user, only: %i[show favorite]
  before_action :admin_checker, only: %i[admin]

  def show
  end

  def favorite
    @favorite_contents = @user.favorited_contents.page(params[:page]).per(PER_PAGE)
  end

  def admin
  end

  def set_user
    @user = current_user
    redirect_to root_path, alert: "不正なアクセスです" if @user.nil?
  end
end
