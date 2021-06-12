class ImportController < ApplicationController
  def create
    Content.import_csv(file: params[:file]) if params[:file].present?
    redirect_to mypage_path(current_user), notice: "データをインポートしました"
  end
end
