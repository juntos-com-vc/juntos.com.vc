S3DirectUpload.config do |c|
  c.access_key_id = ENV['AWS_ACCESS_KEY']
  c.secret_access_key = ENV['AWS_SECRET_KEY']
  c.bucket = ENV['AWS_BUCKET'],
  c.region = 'sa-east-1'
  c.url = "https://#{ENV['AWS_BUCKET']}.s3.amazonaws.com"
end
