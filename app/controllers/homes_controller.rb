class HomesController < ApplicationController
  def index
    # TODO: 以下のコードに公開コンテンツのみ表示させること
    # @popularity_contents = Content.order_populer.first(TOP_PAGE_CONTENT) # TODO: 人気ベスト10をランダムに表示
    @popularity_contents = Content.published.order(created_at: :desc).first(TOP_PAGE_CONTENT)
    @recommend_contents = Content.published.recommend.order("RAND()").limit(TOP_PAGE_CONTENT)
    @new_contents = Content.published.order(created_at: :desc).first(TOP_PAGE_CONTENT)
    @categories = Category.first(TOP_PAGE_CONTENT)
    @content_tags = TagMaster.all
  end
end
