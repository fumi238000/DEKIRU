class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy]
  before_action :set_review, only: %i[destroy]

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
    @review.destroy!
    redirect_to content_show_path(@review.content.id), alert: "レビューを削除しました"
  end

  private

    def set_review
      case current_user.user_type
      when "admin"
        @review = Review.find(params[:id])
      when "general"
        @review = current_user.reviews.find_by(id: params[:id])
        redirect_to root_path, alert: "権限がありません" if @review.nil?
      end
    end

    def review_params
      params.require(:review).permit(:content_id, :image, :comment).
        merge(user_id: current_user.id)
    end
end
