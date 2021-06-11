class Content < ApplicationRecord
  has_many :materials, dependent: :destroy
  has_many :makes, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :users
  has_many :questions, dependent: :destroy
  has_many :content_tags, dependent: :destroy
  has_many :tag_masters, through: :content_tags
  belongs_to :category, optional: true

  validates :title, presence: true, length: { in: 1..16, allow_blank: true }
  validates :subtitle, presence: true, length: { in: 1..32, allow_blank: true }
  validates :comment, presence: true, length: { in: 1..32, allow_blank: true }
  validates :point, presence: true, length: { in: 1..32, allow_blank: true }
  validate :tag_master_ids, :content_tag_checker
  # TODO: movie_urlバリデージョン実装時に実装する
  # validates :movie_url, presence: true
  # validates recommend_status:, presence: true

  enum recommend_status: { general: 0, recommend: 1 }
  enum public_status: { non_published: 0, published: 1 }

  # TODO: サムネイル画像のURLを保存するかどうか検討
  # mount_uploader :movie_thumbnail, MovieThumbnailUploader
  MAX_CONTENT_TAGS = Settings.max_countent_tags

  # お気に入り判定
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # お気に入りが多い順番で取得
  def self.order_populer
    Kaminari.paginate_array(self.find(Favorite.group(:content_id).order("count(content_id) desc").pluck(:content_id)))
  end

  # 動画保存処理
  before_save do
    format_url = YoutubeUrlFormatter.url_format(movie_url)
    if format_url.present?
      self.movie_url = format_url
    else
      # 失敗した場合はバリデーションエラーを出す
      self.errors.add(:movie_url, "YouTubeのURL以外は無効です")
      throw(:abort)
    end
  end

  # タグを登録数の制限
  def content_tag_checker
    unless self.tag_masters.content.count <= MAX_CONTENT_TAGS
      errors.add(:tag_master_ids, "の登録できる上限を超えています。（タグは#{MAX_CONTENT_TAGS}つまで）")
    end
  end
end
