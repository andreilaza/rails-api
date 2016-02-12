require 'aws-sdk'

class Api::V1::ImagesController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  ### ROUTE METHODS ###
  def process_image
    set_aws_credentials

    s3 = Aws::S3::Client.new

    hex = SecureRandom.hex(4)    

    original_image = Aws::S3::Object.new(ENV["AWS_BUCKET"], params[:path_from])
    original_image_url = original_image.presigned_url(:get, expires_in: 90.seconds)
    
    # take acl from original image
    image = MiniMagick::Image.open(original_image_url)
    # render json: { url: original_image_url}, status: 201, root: false
    image.auto_orient
    image = yield(image) if block_given?
    
    if params[:crop] == 'square'
      image = resize_and_crop_square(image, params[:size])
    elsif params[:crop] == 'widescreen'
      image = resize_and_crop_widescreen(image, params[:size])
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
end