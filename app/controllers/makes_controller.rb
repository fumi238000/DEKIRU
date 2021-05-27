class MakesController < ApplicationController
  before_action :admin_checker, only: %i[new create update edit destroy]
  before_action :set_make, only: %i[update edit destroy]

  def new
    @content_id = params[:content_id]
    @make = Make.new
  end

  def create
    @make = Make.new(make_params)
    if @make.save
      redirect_to content_show_path(@make.content.id), notice: "作り方を追加しました"
    else
      render :new
    end
  end

  def update
    if @make.update(make_params)
      redirect_to content_show_path(@make.content.id), notice: "作り方を更新しました"
    else
      render :edit
    end
  end

  def edit
    @content_id = params[:content_id]
  end

  def destroy
    @make.destroy!
    redirect_to content_show_path(@make.content.id), alert: "作り方を削除しました"
  end

  private

    def set_make
      @make = Make.find(params[:id])
    end

    def make_params
      params.require(:make).permit(:content_id, :detail)
    end
end
