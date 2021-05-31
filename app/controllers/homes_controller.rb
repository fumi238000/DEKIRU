class HomesController < ApplicationController
  # # TODO: 共通化すること
  TOP_PAGE_CONTENT = 3 # おすすめコンテンツの最大数

  def index
    @popularity_contents = Content.first(TOP_PAGE_CONTENT) # TODO: 人気ベスト10をランダムに表示
    # @popularity_contents = Content.order("RAND()").first(TOP_PAGE_CONTENT) # TODO: 人気ベスト10をランダムに表示
    @recommend_contents = Content.recommend.order("RAND()").limit(TOP_PAGE_CONTENT)
    @new_contents = Content.order(created_at: :desc).first(TOP_PAGE_CONTENT)
    @categories = Category.includes(:contents).first(TOP_PAGE_CONTENT)
    @content_tags = TagMaster.all
    # # タグ検索
    # if params[:tag_id]
    #   @creators = TagMaster.find_by(id: params[:tag_id]).creators.joins(:menus).includes(:creator_tags, :tag_masters, :menus)
    # end
  end
end
