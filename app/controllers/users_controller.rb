class UsersController < ApplicationController
  before_action :set_user, only: %i[show favorite]

  def show
    @content_tags = TagMaster.all
  end

  def favorite
    @favorite_contents = @user.favorited_contents.page(params[:page]).per(PER_PAGE)
  end

  def set_user
    @user = current_user
    redirect_to root_path, alert: "不正なアクセスです" if @user.nil?
  end
end
