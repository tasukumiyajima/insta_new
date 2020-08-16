class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process resize_to_fill: [612, 612, "Center"]

  storage :file

  # アップロードファイルの保存先ディレクトリは上書き可能
  # 下記はデフォルトの保存先
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # アップロード可能な拡張子のリスト
  def extension_whitelist
    %w(jpg jpeg png)
  end
end
