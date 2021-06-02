class CategoriesController < ApplicationController
  before_action :admin_checker, only: %i[index new create update edit destroy]
  before_action :set_category, only: %i[show update edit destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def show
    @contents = @category.contents.page(params[:page]).per(PER_PAGE)
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "カテゴリーを作成しました"
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: "カテゴリーを更新しました"
    else
      render :edit
    end
  end

  def edit
    @content_id = params[:content_id]
  end

  def destroy
    @category.destroy!
    redirect_to categories_path, alert: "カテゴリーを削除しました"
  end

  private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end
end
