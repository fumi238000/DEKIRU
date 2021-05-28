class ReviewsController < ApplicationController
  before_action :admin_checker, only: %i[new create destroy]
  before_action :set_review, only: %i[destroy]
  # TODO: 管理者ユーザーはレビューを登録できない様にする

  def new
    @review = Review.new
    @content_id = params[:content_id]
  end

  def create
    @review = Review.new(review_params)
    if @review.save
      redirect_to content_show_path(@review.content.id), notice: "レビューを追加しました"
    else
      render :new
    end
  end

  def destroy
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
