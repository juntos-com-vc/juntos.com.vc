S3DirectUpload.config do |c|
  c.access_key_id = CatarseSettings.get_without_cache(:aws_access_key)
  c.secret_access_key = CatarseSettings.get_without_cache(:aws_secret_key)
  c.bucket = CatarseSettings.get_without_cache(:aws_bucket)
  c.region = 's3-sa-east-1'
end
