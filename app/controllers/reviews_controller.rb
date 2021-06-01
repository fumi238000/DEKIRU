class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy]
  before_action :set_review, only: %i[destroy]
  # TODO: 管理者ユーザーはレビューを登録できない様にするか検討

  def new
    @review = Review.new
    @content_id = params[:content_id]
  end

  def create
    @review = Review.new(review_params)
    if @review.save
      redirect_to content_show_path(@review.content.id), notice: "レビューを追加しました"
    else
      @content_id = review_params[:content_id]
      render :new
    end
  end

  def destroy
    # 削除できる様にするか検討する
  end

  private

    def set_review
      @review = Review.find(params[:id])
    end

    def review_params
      params.require(:review).permit(:content_id, :image, :comment).
        merge(user_id: current_user.id)
    end
end
