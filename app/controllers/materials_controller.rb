class MaterialsController < ApplicationController
  before_action :admin_checker, only: %i[new create update edit destroy]
  before_action :set_material, only: %i[update edit destroy]

  def new
    @content_id = params[:content_id]
    @material = Material.new
  end

  def create
    @material = Material.new(material_params)
    if @material.save
      redirect_to content_show_path(@material.content.id), notice: "材料を追加しました"
    else
      render :new
    end
  end

  def update
    if @material.update(material_params)
      redirect_to content_show_path(@material.content.id), notice: "材料を更新しました"
    else
      render :edit
    end
  end

  def edit
    @content_id = params[:content_id]
  end

  def destroy
    @material.destroy!
    redirect_to content_show_path(@material.content.id), alert: "材料を削除しました"
  end

  private

    def set_material
      @material = Material.find(params[:id])
    end

    def material_params
      params.require(:material).permit(:content_id, :name, :amount, :unit)
    end
end
