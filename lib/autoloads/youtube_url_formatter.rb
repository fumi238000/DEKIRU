class YoutubeUrlFormatter
  # iframe タグの src 属性のURLを取得するための正規表現
  SRC_REGEX = /src\s*=\s*"([^"]*)"/.freeze
  # URL から 動画ID を取得するための正規表現
  YOUTUBE_ID_REGEX = %r{\A(?:http(?:s)?://)?(?:www\.)?(?:m\.)?(?:youtu\.be/|youtube\.com/(?:(?:watch)?\?(?:.*&)?v(?:i)?=|(?:embed|v|vi|user)/))([^?&"'>]+)(&t=.*)?\z}.freeze #rubocop:disable all

  def self.url_format(url)
    # YouTube の埋め込み用 iframeの場合 → src 属性のURLに置き換え
    url = src_match[1] if SRC_REGEX.match(url)
    # YouTube動画の場合 → 埋め込み用URL, それ以外 → nil
    youtube_id = YOUTUBE_ID_REGEX.match(url)

    if youtube_id
      "https://www.youtube.com/embed/#{youtube_id[1]}"
    end
  end

  def self.movie_id_format(url)
    src_match = SRC_REGEX.match(url)
    url = src_match[1] if src_match
    youtube_movie_id = YOUTUBE_ID_REGEX.match(url)
    if youtube_movie_id
      youtube_movie_id[1]
    end
  end
end
