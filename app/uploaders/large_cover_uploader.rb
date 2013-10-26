class LargeCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  if Rails.env.production?
    storage :fog
  end

  process :resize_to_fill => [665, 375]
end