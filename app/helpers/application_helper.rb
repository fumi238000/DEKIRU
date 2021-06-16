module ApplicationHelper
  def admin_user?
    return false unless user_signed_in?

    current_user.admin?
  end

  def general_user?
    return false unless user_signed_in?

    current_user.general?
  end

  def permit_user?(params)
    return false unless user_signed_in?

    params.user_id == current_user.id || current_user.admin?
  end

  # youtubeのサムネイル画像を取得
  def youtube_thumbnail(movie_id)
    "http://img.youtube.com/vi/#{movie_id}/mqdefault.jpg"
  end
end
