require 'aws-sdk'

class Api::V1::ImagesController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def process_image
    set_aws_credentials

    s3 = Aws::S3::Client.new

    hex = SecureRandom.hex(4)    

    original_image = avatar = Aws::S3::Object.new(ENV["AWS_BUCKET"], params[:path_from])
    original_image_url = original_image.presigned_url(:get, expires_in: 90.seconds)

    # take acl from original image
    image = MiniMagick::Image.open(original_image_url)

    if params[:crop]
      image = resize_and_crop(image, params[:width])
    else
      image.resize "#{params[:width]}x#{params[:height]}"
    end
        
    bucket = Aws::S3::Bucket.new(ENV["AWS_BUCKET"], client: s3)
    avatar = Aws::S3::Object.new(ENV["AWS_BUCKET"], params[:path_to])

    # from an IO object
    File.open(image.path, 'rb') do |file|
      if params[:acl]
        acl = params[:acl]
      else
        acl = "public-read"
      end

      avatar.put(body:file, acl: acl)
    end    
    render json: { url: avatar.presigned_url(:get, expires_in: 90.seconds)}, status: 201, root: false
  end

  private
    def resize_and_crop(image, size)
      if image.width < image.height   
        remove = ((image.height - image.width)/2).round 
        image.shave("0x#{remove}") 
      elsif image.width > image.height 
        remove = ((image.width - image.height)/2).round
        image.shave("#{remove}x0")
      end
      image.resize("#{size}x#{size}")
      image
    end    
end