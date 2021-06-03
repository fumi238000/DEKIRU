class HomesController < ApplicationController
  def index
    @popularity_contents = Content.order_populer.first(TOP_PAGE_CONTENT) # TODO: 人気ベスト10をランダムに表示
    @recommend_contents = Content.recommend.order("RAND()").limit(TOP_PAGE_CONTENT)
    @new_contents = Content.order(created_at: :desc).first(TOP_PAGE_CONTENT)
    @categories = Category.includes(:contents).first(TOP_PAGE_CONTENT)
    @content_tags = TagMaster.all
  end
end
