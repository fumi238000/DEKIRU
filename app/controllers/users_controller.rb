class UsersController < ApplicationController
  before_action :set_user, only: %i[show]

  def show
    @content_tags = TagMaster.all
  end

  def set_user
    # ここでログインユーザー出ないとエラーが出る様にする
    @user = User.find_by(id: current_user)
  end
end
