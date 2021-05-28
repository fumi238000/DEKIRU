class FavoritesController < ApplicationController
  def create
    @content = Content.find(params[:content_id])
    current_user.favorites.create!(content_id: @content.id)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @content = Content.find(params[:content_id])
    current_user.favorites.find_by(content_id: @content.id).destroy!
    redirect_back(fallback_location: root_path)
  end
end
