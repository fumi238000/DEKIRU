class TagMastersController < ApplicationController
  before_action :admin_checker, only: %i[new create update edit destroy]
  before_action :set_tag_master, only: %i[update edit destroy]

  def index
    @tags = TagMaster.order(created_at: :asc)
  end

  def new
    @tag_master = TagMaster.new
  end

  def create
    @tag_master = TagMaster.new(tag_master_params)
    if @tag_master.save
      redirect_to tag_masters_path, notice: "キーワードを追加しました"
    else
      render :new
    end
  end

  def update
    if @tag_master.update(tag_master_params)
      redirect_to tag_masters_path, notice: "キーワードを更新しました"
    else
      render :edit
    end
  end

  def edit
  end

  def destroy
    @tag_master.destroy!
    redirect_to tag_masters_path, alert: "キーワードを削除しました"
  end

  private

    def set_tag_master
      @tag_master = TagMaster.find(params[:id])
    end

    def tag_master_params
      params.require(:tag_master).permit(:tag_name, :tag_type)
    end
end
