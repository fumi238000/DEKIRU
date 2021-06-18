class ContentsController < ApplicationController
  before_action :admin_checker, only: %i[new create update edit destroy]
  before_action :set_content, only: %i[show update edit destroy]
  MAIL_ADMIN = ENV["MAIL_ADMIN"]

  def index
    contents = Content.order(id: :asc)
    # エクスポート
    respond_to do |format|
      format.html
      format.csv do
        send_data(contents.generate_csv, filename: "contents.csv")
      end
    end
    @contents = contents.page(params[:page]).per(PER_PAGE)
  end

  def new
    @content = Content.new
  end

  def show
    @makes = @content.makes
    @materials = @content.materials
    @reviews = @content.reviews.includes(:user)
    @questions = @content.questions.includes(:user, :response)
    @question = Question.new
    @admin = User.find_by(email: MAIL_ADMIN)
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
    redirect_to root_path, alert: "【#{@content.title}】を削除しました"
  end

  def popular
    @popular_contents = Content.order_populer.page(params[:page]).per(PER_PAGE)
  end

  def newest
    @new_contents = Content.published.order(created_at: :desc).page(params[:page]).per(PER_PAGE)
  end

  def recommend
    @recommend_contents = Content.published.recommend.order("RAND()").limit(RECOMMEND_CONTENT_NUM)
  end

  def search
    # キーワード検索
    if params[:tag_id]
      @search_word = TagMaster.find_by(id: params[:tag_id]).tag_name
      @contents = TagMaster.find_by(id: params[:tag_id]).contents.published.page(params[:page]).per(PER_PAGE)
    end
    # MEMO: 条件検索はapplication_controllerに記載
  end

  private

    def set_content
      @content = Content.find(params[:id])
    end

    def content_params
      movie_id = YoutubeUrlFormatter.movie_id_format(params[:content][:movie_url])
      params.require(:content).permit(:title, :subtitle, :movie_url, :comment, :point, :public_status, :recommend_status, :category_id,
                                      tag_master_ids: []).merge(movie_id: movie_id)
    end
end
