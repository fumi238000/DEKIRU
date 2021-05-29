class ThumbnailUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # 開発環境・本番環境で使用する場合(ローカルテスト用)
  # storage :fog

  # 本番環境のみ使用する場合
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # ファイル形式の制限
  def extension_allowlist
    %w[jpg jpeg png]
  end

  # 画像ファイルサイズの制限（5MB）
  def size_range
    0..5.megabytes
  end

  # 画像サイズ
  process resize_to_fill: [150, 150, "Center"]

  # サムネイル画像
  # コンテンツ詳細(27px)
  version :thumb27 do
    process resize_to_fit: [27, 27]
  end

  # version :thumb65 do
  #   process resize_to_fit: [65, 65]
  # end

  # version :thumb110 do
  #   process resize_to_fit: [110, 110]
  # end

  # デフォルト画像
  def default_url(*args)
    "/images/fallback/" + [version_name, "thumbnail_default.png"].compact.join("_") #rubocop:disable all
  end

  # jpg に変換
  # process convert: "jpg"

  # ファイル名の拡張子を jpg に変更
  # def filename
  # super.chomp(File.extname(super)) + ".jpg" if original_filename.present?
  # end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected

    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
    end
end
