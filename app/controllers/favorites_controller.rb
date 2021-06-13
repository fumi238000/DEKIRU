class FavoritesController < ApplicationController
  def create
    @content = Content.find(params[:content_id])
    current_user.favorites.create!(content_id: @content.id)
  end

  def destroy
    @content = Content.find(params[:content_id])
    current_user.favorites.find_by(content_id: @content.id).destroy!
  end
end
