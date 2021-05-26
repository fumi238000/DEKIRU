class ContentsController < ApplicationController
  # TODO: adminユーザー出ない場合、リダイレクトする処理を実装する
  before_action :admin_check, only: %i[new create update edit destroy]
  before_action :set_content, only: %i[show update edit destroy]

  def index
    @contents = Content.all
    # @contents = Content.includes([:materials, :makes])
  end

  def new
    @content = Content.new
  end

  def show
  end

  def create
    @content = Content.new(content_params)
    if @content.save
      redirect_to content_show_path(id: @content.id), notice: "【#{@content.title}】を作成しました"
    else
      render :new
    end
  end

  def update
    if @content.update(content_params)
      redirect_to content_show_path(id: @content.id), notice: "【#{@content.title}】の内容を更新しました"
    else
      render :edit
    end
  end

  def edit
  end

  def destroy
    @content.destroy!
    redirect_to contents_path, alert: "【#{@content.title}】を削除しました"
  end

  private

    def set_content
      @content = Content.find(params[:id])
    end

    def content_params
      params.require(:content).permit(:title, :subtitle, :movie_url, :comment, :point)
    end

    def admin_check
      ## ログインしているか
      redirect_to root_path, alert: "不正なアクセスです" and return unless user_signed_in?
      ## ログインユーザーが管理者か
      redirect_to root_path, alert: "不正なアクセスです" and return unless current_user.admin?
    end
end
