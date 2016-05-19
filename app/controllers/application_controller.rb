class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.  
  protect_from_forgery with: :null_session
  serialization_scope :current_user
  # before_filter :set_headers 
  include Authenticable
   
  def index        
    send("#{current_user.role_name}_index")
  end
  
  def show    
    send("#{current_user.role_name}_show")
  end

  def create
    send("#{current_user.role_name}_create")
  end
  
  def update
    send("#{current_user.role_name}_update")
  end

  def destroy
    send("#{current_user.role_name}_destroy")
  end

  def add_asset(params)

    asset = Asset.where(:entity_id => params['entity_id'], :entity_type => params['entity_type'], :definition => params['definition']).first

    if asset && asset.entity_type != 'section' && asset.definition != 'content'
      if asset.entity_type == 'course' && asset.definition == 'teaser'
        asset = Asset.new(params)
        asset.save
      end

      asset['path'] = params['path']

      if params['metadata']
        asset['metadata'] = params['metadata']
      end

      asset.save
    else
      if asset && asset.definition == 'subtitles'
        asset['path'] = params['path']

        if params['metadata']
          asset['metadata'] = params['metadata']
        end

        asset.save
      else
        asset = Asset.new(params)
        asset.save
      end      
    end

    asset
  end

  def serialize_section(section)
    serializer = CustomSectionSerializer.new(section, scope: serialization_scope, root: false).as_json
  end

  def set_aws_credentials()
    credentials = {
      'AccessKeyId' => ENV["ADMIN_AWS_KEY_ID"],
      'SecretAccessKey' => ENV["ADMIN_AWS_ACCESS_KEY"],
      'Bucket' => ENV["AWS_BUCKET"],
      'SeedBucket' => ENV["AWS_SEED_BUCKET"]
    } 

    Aws.config[:region] = ENV["AWS_REGION"]
    Aws.config[:credentials] = Aws::Credentials.new(credentials['AccessKeyId'], credentials['SecretAccessKey'])
  end

  def build_output(user, token = true)
    # convert user to json to add the auth token field to it    
    output = ActiveSupport::JSON.decode(user.to_json)
    
    if token
      output["auth_token"] = user.auth_token
    end

    if output["role"] == User::ROLES[:admin]
      output["role"] = 'admin'
    end

    if output["role"] == User::ROLES[:estudent]
      output["role"] = 'estudent'
    end

    if output["role"] == User::ROLES[:author]
      output["role"] = 'author'

      if !token
        author_metadata = UserMetadatum.where(user_id: user.id).first
        if author_metadata
          output["facebook"] = author_metadata.facebook
          output["website"] = author_metadata.website
          output["twitter"] = author_metadata.twitter
          output["linkedin"] = author_metadata.linkedin
          output["biography"] = author_metadata.biography
          output["position"] = author_metadata.position
          output["website"] = author_metadata.website
        end
      end
    end

    if output["role"] == User::ROLES[:institution_admin]
      output["role"] = 'institution_admin'
    end
    
    asset = Asset.where('entity_id' => user.id, 'entity_type' => 'user', 'definition' => 'avatar').first
    
    if asset
      output["avatar"] = asset.path
    else
      output["avatar"] = nil
    end    

    output.to_json    
  end  

  def slugify(item)
    item = clean_title(item)

    item.parameterize
  end

  def clean_title(item)
    if item
      item.gsub! 'ț', 't'
      item.gsub! 'ă', 'a'
      item.gsub! 'î', 'i'
      item.gsub! 'â', 'a'
      item.gsub! 'ș', 's'

      item.gsub! 'Ț', 'T'
      item.gsub! 'Â', 'A'
      item.gsub! 'Î', 'I'
      item.gsub! 'Ă', 'A'
      item.gsub! 'Ș', 'S'
    end
    
    item
  end
  
  def resize_and_crop_square(image, size)
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

  def resize_and_crop_widescreen(image, size)
    width = image.width
    height = image.height
    
    expected_ratio = 16 / 9
    image_ratio = width / height

    if image_ratio > expected_ratio
      remove = ((width - 16 * height / 9)/2).round
      width = width - remove * 2
      image.shave("#{remove}x0")
    else
      remove = ((height - 9 * width / 16)/2).round
      height = height - remove * 2
      image.shave("0x#{remove}") 
    end
    
    image.resize("#{width}x#{size}")
    image
  end  
end