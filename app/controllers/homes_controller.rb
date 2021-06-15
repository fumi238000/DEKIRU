class HomesController < ApplicationController
  def index
    @popular_contents = Content.order_populer.first(TOP_PAGE_CONTENT)
    @recommend_contents = Content.published.recommend.order("RAND()").limit(TOP_PAGE_CONTENT)
    @new_contents = Content.published.order(created_at: :desc).first(TOP_PAGE_CONTENT)
    @categories = Category.order("RAND()").first(TOP_PAGE_CONTENT)
    @content_tags = TagMaster.order("RAND()")
  end
end
