class HomesController < ApplicationController
  # TODO: 共通化すること
  TOP_PAGE_CONTENT = 3 # おすすめコンテンツの最大数

  def index
    @popularity_contents = Content.order("RAND()").first(TOP_PAGE_CONTENT) # TODO: 人気ベスト10をランダムに表示
    @recommend_contents = Content.recommend.order("RAND()").limit(TOP_PAGE_CONTENT)
    @new_contents = Content.order(created_at: :desc).first(TOP_PAGE_CONTENT)
  end
end
