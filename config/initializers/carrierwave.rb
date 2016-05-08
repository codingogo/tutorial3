CarrierWave.configure do |config|
  config.storage = :aws
  config.aws_bucket = EV.fetch('S3_BUCKET_NAME')
  config.aws_acl = 'public-read'

  config.aws_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV["aws_access_key_id"],
    :aws_secret_access_key  => ENV["aws_secret_access_key"],
    :region  => 'ap-northeast-2'
  }

end