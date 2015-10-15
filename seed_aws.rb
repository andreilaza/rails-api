require 'aws-sdk'
require 'json'

# credentials = JSON.load(File.read('secrets.json'))
credentials = {
  'AccessKeyId' => ENV["ADMIN_AWS_KEY_ID"],
  'SecretAccessKey' => ENV["ADMIN_ADMIN_AWS_KEY_ID"],
  'Bucket' => ENV["AWS_BUCKET"],
  'SeedBucket' => ENV["AWS_SEED_BUCKET"]
} 
Aws.config[:region] = 'eu-central-1'
Aws.config[:credentials] = Aws::Credentials.new(credentials['AccessKeyId'], credentials['SecretAccessKey'])

s3 = Aws::S3::Client.new

bucket = Aws::S3::Bucket.new(credentials['Bucket'], client: s3)

bucket.delete!

bucket.create

seed_bucket = Aws::S3::Bucket.new(credentials['SeedBucket'], client: s3)

seed_bucket.objects.each do |object|
  
  new_object = Aws::S3::Object.new(credentials['Bucket'], object.key)

  new_object.copy_from(bucket: credentials['SeedBucket'], key: object.key, multipart_copy: true)
end