class UsersController < ApplicationController
  before_action :set_user, only: %i[show favorite]
  before_action :admin_checker, only: %i[index edit update admin]
  before_action :set_sidebar, only: %i[favorite]

  def index
    @users = User.order(created_at: :asc)
  end

  def show
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      redirect_to users_path, notice: "ユーザーのステータスを更新しました"
    else
      render :edit
    end
  end

  def edit
    @user = User.find(params[:id])
    redirect_to users_path, alert: "管理者は編集できません" if @user.admin?
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

  def user_params
    params.require(:user).permit(:user_type)
  end
end
