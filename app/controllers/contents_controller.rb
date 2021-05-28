class ContentsController < ApplicationController
  before_action :admin_checker, only: %i[new create update edit destroy]
  before_action :set_content, only: %i[show update edit destroy]
  RECOMMEND_CONTENT_NUM = 9 # おすすめコンテンツの最大数
  PER_PAGE = 12 # 1ページの表示数

  def index
    @contents = Content.all
    # @contents = Content.includes([:materials, :makes])
  end

  def new
    @content = Content.new
  end

  def show
    @makes = @content.makes
    @materials = @content.materials
    @reviews = @content.reviews.includes(:user)
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
      redirect_to content_show_path(id: @content.id), notice: "内容を更新しました"
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

  def popular
    @popular_contents = Content.all.page(params[:page]).per(PER_PAGE)
    # TODO: お気に入りの数で判定する
    # @contents = Content.includes(:favorites)#.order("favorites.date DESC")
  end

  def newest
    @new_contents = Content.order(created_at: :desc).page(params[:page]).per(PER_PAGE)
  end

  def recommend
    @recommend_contents = Content.recommend.order("RAND()").limit(RECOMMEND_CONTENT_NUM)
    # @recomend_contents = Content.recommend.order("RAND()").limit(RECOMMEND_CONTENT_NUM).page(params[:page]).per(PER_PAGE) # ページネーションの場合
  end

  private

    def set_content
      @content = Content.find(params[:id])
    end

    def content_params
      params.require(:content).permit(:title, :subtitle, :movie_url, :comment, :point)
    end
end
