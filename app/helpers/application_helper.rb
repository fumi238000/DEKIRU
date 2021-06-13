module ApplicationHelper
  ## TODO: リファクタリングを検討する
  def admin_user?
    if user_signed_in?
      current_user.admin?
    end
  end

  def general_user?
    if user_signed_in?
      current_user.general?
    end
  end

  def permit_user?(params)
    if user_signed_in?
      params.user_id == current_user.id || current_user.admin?
    end
  end

  # youtubeのサムネイル画像を取得
  def youtube_thumbnail(movie_id)
    "http://img.youtube.com/vi/#{movie_id}/mqdefault.jpg"
  end
end
