class HomesController < ApplicationController
  def index
    @popular_contents = Content.order_populer.first(TOP_PAGE_CONTENT)
    @recommend_contents = Content.published.recommend.order("RAND()").limit(TOP_PAGE_CONTENT)
    @new_contents = Content.published.order(created_at: :desc).first(TOP_PAGE_CONTENT)
    @categories = Category.order("RAND()").first(TOP_PAGE_CONTENT)
    @category_names = Category.order(created_at: :desc)
    @content_tags = TagMaster.where(id: TagMaster.pluck(:id) & ContentTag.pluck(:tag_id)).order("RAND()")
  end
end
